import { LightningElement, api,wire,track } from 'lwc';
//import getOpportunityRecordMethod from '@salesforce/apex/MyComponentController.getOpportunityRecordMethod';
import getOpportunityRecordMethod from '@salesforce/apex/PDFServiceIntegration.getOpportunityRecordMethod';
import uploaddocs from '@salesforce/apex/PDFServiceIntegration.uploaddocs';
import { NavigationMixin } from 'lightning/navigation'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';




export default class fileUploadcomp extends NavigationMixin( LightningElement ) {

    @api recordId;
    fileName;
    strContentDocId;
    @track OpportunityRecord;
    @track isLoading = false; // Spinner control
    @track error;

    @wire(getOpportunityRecordMethod,{ recordId: '$recordId'})
    
    
    OpportunityData({ error, data }) {
        this.isLoading= true; //show spinner
        if (data) {

            console.log('RecordId is',JSON.stringify(data));

            this.OpportunityRecord = data;

            this.error = undefined;

        } else if (error) {

            console.log('Error block', JSON.stringify(error));

            this.error = error;

            this.accountRecord = undefined;

        }
        this.isLoading= false; //Hide spinner
      };


     

    get acceptedFormats() {

        return [
            '.jpeg', 
            '.png',
            '.docx',
            '.doc',
            '.pdf',
            '.csv',
            '.xlsx',
            '.xls',
            '.jpg'
        ];

    }

    handleUploadFinished( event ) {
        this.isLoading = true; // show spinner while file is uploaded
        let uploadedFilesList = event.detail.files;
        let uploadedFile = uploadedFilesList[0];
        console.log('uploadedFile is',JSON.stringify(uploadedFile));
        //  this.dispatchEvent(
        //     new CustomEvent('updateid',{
        //         detail: uploadedFile
        // );
        // this.strContentDocId = uploadedFile.documentId;
        // console.log(
        //     'content file is',this.strContentDocId
            
        //     )
        this.fileName = uploadedFile.name;
        this.strContentDocId = uploadedFile.documentId;
        console.log('Content file is', this.strContentDocId);
        uploaddocs({strContentDocId: this.strContentDocId})
        .then(result => {
            console.log('File uploaded successfully:', result);
            this.showToast('Success', 'File uploaded successfully!', 'success');
        })
        .catch(error => {
            console.error('Error uploading file:', error);
            this.showToast('Error', 'File not uploaded successfully!  ${error.body.message}', 'error');
        })

        .finally (() => {
            this.isLoading = false; // Hide spinner after upload
        });

    }

    // Show toast notification
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    previewImage() {

        this[ NavigationMixin.Navigate ] ( {
            type: 'standard__namedPage',
            attributes: {
                pageName: 'filePreview'
            },
            state:{ 
                selectedRecordId: this.strContentDocId
            }
        }, false );

    }

}