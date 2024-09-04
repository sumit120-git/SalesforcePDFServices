/*global enum ContentType {
PDF('application/pdf'),
DOCX('application/vnd.openxmlformats-officedocument.wordprocessingml.document');

private String mimeType;

ContentType(String mimeType) {
    this.mimeType = mimeType;
}

public String getMimeType() {
    return mimeType;
}
}*/

public with sharing class PDFServiceIntegration {

    
// Wrapper class to hold the assetId and uploadUri
public class DocAssets {
public String assetId { get; set; }
public String uploadUri { get; set; }

public DocAssets(String assetId, String uploadUri) {
    this.assetId = assetId;
    this.uploadUri = uploadUri;
}
}

// Adobe API credentials
public  String clientId = 'b1195a8aa75c4f1aace4dd30557c2493';
public  String clientSecret = 'p8e-5ADs3Jcrwr0lJLQoD7AZ_8ORXPrJAQFQ';
public  String token = '';
public  String assetId='';
public  String uploaduri='';



@AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunityRecordMethod(String recordId) {

        List<Opportunity> opptyList = new List<Opportunity>();

        if (Opportunity.SObjectType.getDescribe().isAccessible()) {
            opptyList = [SELECT Id, Name, Type, StageName FROM Opportunity WHERE Id = :recordId];
        }

        return opptyList;
    }



// Method to get OAuth token
public String getToken() {
HttpRequest req = new HttpRequest();
req.setEndpoint('https://pdf-services-ue1.adobe.io/token');
req.setMethod('POST');
req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

// Construct the body with the correct grant type
String payload ='&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
                    '&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8');
req.setBody(payload);

System.debug(req);
Http h = new Http();
HttpResponse res = h.send(req);
System.debug(res.getBody());

// Parse the response to extract the access token
Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
token = (String) jsonResponse.get('access_token');

System.debug('Access Token: ' + token);
return token;
}

// Upload URL from Assets 
public DocAssets getdocAssets() {
// Ensure token is available
if (String.isBlank(token)) {
    token = getToken();
}

HttpRequest req = new HttpRequest();
req.setEndpoint('https://pdf-services-ew1.adobe.io/assets');
req.setMethod('POST');
req.setHeader('Content-Type', 'application/json');
req.setHeader('x-api-key',EncodingUtil.urlEncode(clientId, 'UTF-8'));
req.setHeader('Authorization', 'Bearer ' + token);

// Properly format the payload as a JSON string
String payload = '{"mediaType": "application/vnd.openxmlformats-officedocument.wordprocessingml.document"}';
req.setBody(payload);

System.debug(req);
Http h = new Http();
HttpResponse res = h.send(req);
System.debug(res.getBody());
System.debug(res);
    //Parse the response to extract the asset id and upload url
Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

uploaduri = (String)jsonResponse.get('uploadUri');
system.debug(uploaduri);
assetId = (String) jsonResponse.get('assetID');

System.debug('assetId: ' + assetId);

    
return new DocAssets(assetId, uploadUri);
}



//Put request to upload the documents in upload URI




@AuraEnabled
public static void uploaddocs(String strContentDocId) {
    // Call getdocAssets() to get the assetId and uploadUri
    PDFServiceIntegration service = new PDFServiceIntegration();
    DocAssets docAssets = service.getdocAssets();
    if (docAssets == null || String.isBlank(docAssets.uploadUri)) {
        System.debug('Failed to retrieve upload URI.');
        return;
    }

    String uploadUri = docAssets.uploadUri;
    // Check if the content document ID is not empty
    if (String.isBlank(strContentDocId)) {
        System.debug('Content Document ID is blank or null');
        return;
    }

    // Check if the user has read access on ContentVersion object
    if (!Schema.sObjectType.ContentVersion.isAccessible()) {
        throw new SecurityException('You do not have permission to access ContentVersion records.');
    }

    // Check if the user has read access on specific fields (if necessary)
    if (!Schema.sObjectType.ContentVersion.fields.ContentDocumentId.isAccessible() ||
        !Schema.sObjectType.ContentVersion.fields.VersionData.isAccessible()) {
        throw new SecurityException('You do not have permission to access the required fields on ContentVersion.');
    }

    // Example of initializing the uploaduri if needed
    //if (String.isBlank(uploaduri)) {
        //uploaduri = new PDFServiceIntegration().getDocAssets();
    

    // Query for ContentVersion records (CRUD check passed)
    List<ContentVersion> lst = [
        SELECT Id, ContentBodyId, ContentDocumentId, ContentSize, FileType, FileExtension, VersionData 
        FROM ContentVersion 
        WHERE ContentDocumentId = :strContentDocId 
        LIMIT 1
    ];

    if (lst.isEmpty()) {
        System.debug('No ContentVersion found for the given ContentDocumentId.');
        return;  // Exit the method if no records are found
    }

    // Get the blob data
    Blob pdfBlob = lst[0].VersionData;
    System.debug('File body length: ' + pdfBlob.size());

    // Set the body of the HTTP request
    HttpRequest req = new HttpRequest();
    req.setEndpoint(uploaduri);
    req.setMethod('PUT');
    req.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document');
    req.setBodyAsBlob(pdfBlob);

    // Perform HTTP callout
    Http h = new Http();
    HttpResponse res;
    try {
        res = h.send(req);
    } catch (Exception e) {
        System.debug('HTTP Callout failed: ' + e.getMessage());
        return;
    }

    // Handle the response
    if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
        System.debug('File uploaded successfully.');
    } else {
        System.debug('Failed to upload file. Status: ' + res.getStatus() + ', Body: ' + res.getBody());
        System.debug('Response Headers: ' + res.getHeaderKeys());
    }


}

//Download Pre-Signed URL 
@AuraEnabled
public String getpresignedURI() {
    
    // Call getdocAssets() to get the assetId and uploadUri
    PDFServiceIntegration service = new PDFServiceIntegration();
    DocAssets docAssets = service.getdocAssets();
    if (docAssets == null || String.isBlank(docAssets.assetId)) {
        System.debug('Failed to retrieve upload URI.');
        return null;
    }

    String assetId = docAssets.assetId;

    // Ensure token is available
    if (String.isBlank(token)) {
        token = getToken();
    }
    String url ='https://pdf-services-ew1.adobe.io/assets/'+assetId;

    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod('GET');
    req.setHeader('Content-Type', 'application/json');
    req.setHeader('x-api-key',EncodingUtil.urlEncode(clientId, 'UTF-8'));
    req.setHeader('Authorization', 'Bearer ' + token);
    
    // Properly format the payload as a JSON string
   // String payload = '{"mediaType": "application/vnd.openxmlformats-officedocument.wordprocessingml.document"}';
    //req.setBody(payload);
    
    System.debug(req);
    Http h = new Http();
    HttpResponse res = h.send(req);
    System.debug(res.getBody());
    System.debug(res);
        //Parse the response to extract the asset id and upload url
    Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
    
    String downloadURI = (String)jsonResponse.get('downloadUri');
    system.debug(downloadUri);
   return downloadURI ;
    }


// Method to generate documents
public HttpResponse genDocs() {
// Ensure token is available
if (String.isBlank(token)) {
    token = getToken();
}
 // Call getdocAssets() to get the assetId and uploadUri
 PDFServiceIntegration service = new PDFServiceIntegration();
 DocAssets docAssets = service.getdocAssets();
 if (docAssets == null || String.isBlank(docAssets.uploadUri)) {
     System.debug('Failed to retrieve upload URI.');
     return null ;
 }

 String assetId = docAssets.assetId;

HttpRequest req = new HttpRequest();
req.setEndpoint('https://pdf-services-ue1.adobe.io/operation/documentgeneration');
req.setMethod('POST');
req.setHeader('Content-Type', 'application/json');
req.setHeader('x-api-key',EncodingUtil.urlEncode(clientId, 'UTF-8'));
req.setHeader('Authorization', 'Bearer ' + token);

//  format the payload as a JSON string
String payload = '{"assetID": "'+assetId+'","outputFormat": "pdf","jsonDataForMerge":{'
        + '"author": "Gary Lee",'
        + '"Company": {'
        + '    "Name": "Projected",'
        + '    "Address": "19718 Mandrake Way",'
        + '    "PhoneNumber": "+1-100000098"'
        + '},'
        + '"Invoice": {'
        + '    "Date": "January 15, 2021",'
        + '    "Number": 123,'
        + '    "Items": ['
        + '        {"item": "Gloves", "description": "Microwave gloves", "UnitPrice": 5, "Quantity": 2, "Total": 10},'
        + '        {"item": "Bowls", "description": "Microwave bowls", "UnitPrice": 10, "Quantity": 2, "Total": 20}'
        + '    ]'
        + '},'
        + '"Customer": {'
        + '    "Name": "Collins Candy",'
        + '    "Address": "315 Dunning Way",'
        + '    "PhoneNumber": "+1-200000046",'
        + '    "Email": "cc@abcdef.co.dw"'
        + '},'
        + '"Tax": 5,'
        + '"Shipping": 5,'
        + '"clause": {'
        + '    "overseas": "The shipment might take 5-10 more than informed."'
        + '},'
        + '"paymentMethod": "Cash"'
        + '}}';
req.setBody(payload);

System.debug(req);
Http h = new Http();
HttpResponse res;
try {
    res = h.send(req);
} catch (Exception e) {
    System.debug('HTTP Callout failed: ' + e.getMessage());
    return null;  // Return null if the callout fails
}

// Check the response and return it
if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
    System.debug('Document generated successfully.');
} else {
    System.debug('Failed to generate document. Status: ' + res.getStatus() + ', Body: ' + res.getBody());
}

return res;
}



// Replace these variables with your actual API endpoint and API key
private static final String API_ENDPOINT = 'https://api.example.com/generate/pdf';
private static final String API_KEY = 'your_api_key_here';

// Method to call the PDF service API
public static Blob generatePDF(String inputData) {
// Prepare the HTTP request
HttpRequest req = new HttpRequest();
req.setEndpoint(API_ENDPOINT);
req.setMethod('POST');
req.setHeader('Content-Type', 'application/json');
req.setHeader('Authorization', 'Bearer ' + API_KEY);

// Set the request body (input data for PDF generation)
req.setBody(inputData);

// Send the HTTP request
Http http = new Http();
HttpResponse res = http.send(req);

// Check the response
if (res.getStatusCode() == 200) {
    // Successful response, return the PDF content as Blob
    return res.getBodyAsBlob();
} else {
    // Error handling - you can log or handle the error as needed
    System.debug('Error response from PDF service API: ' + res.getBody());
    return null;
}
}
    


public List<String> requestPdf(String inputData)
{
Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
request.setMethod('GET');
HttpResponse response = http.send(request);
// If the request is successful, parse the JSON response.
if(response.getStatusCode() == 200) {
    // Deserialize the JSON string into collections of primitive data types.
    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    // Cast the values in the 'animals' key as a list
    List<Object> animals = (List<Object>) results.get('animals');
    System.debug('Received the following animals:');
    for(Object animal: animals) {
        System.debug(animal);
    }
}

return null ;

}

}