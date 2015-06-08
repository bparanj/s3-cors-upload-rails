## Step 1 - Configure S3 for CORS

1. Create an Amazon S3 Bucket
2. Click on Properties -> Permissions -> Edit CORS
3. Enter a CORS configuration, such as the following. For security purposes you should restrict the origin further.

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
        <CORSRule>
            <AllowedOrigin>*</AllowedOrigin>
            <AllowedMethod>PUT</AllowedMethod>
            <MaxAgeSeconds>3000</MaxAgeSeconds>
            <AllowedHeader>*</AllowedHeader>
        </CORSRule>
    </CORSConfiguration>
    ```

## Step 2 - Set your AWS Keys and bucket

The application can be configured via the following environment variables.

- `export AWS_ACCESS_KEY_ID='your aws acccess key id'`
- `export AWS_SECRET_ACCESS_KEY='your aws secret access key'`
- `export AWS_S3_BUCKET='example.com'`


## General Flow

This project uses client-side JavaScript and server-side Ruby. In general, the completed file-upload process follows these steps:

1. A file is selected for upload by the user in their web browser;
2. JavaScript is then responsible for making a request to your web application, which produces a temporary signature with which to sign the upload request;
3. The temporary signed request is returned to the browser in JSON format;
4. JavaScript then uploads the file directly to Amazon S3 using the signed request supplied by your Rails application.

## Code overview

The application flow is as follows:

1. [Client] When the user chooses a file, a callback (defined in `app/assets/javascripts/products.js`) contacts the server to request a signed URL that can be used for uploading to S3. 
2. [Server] AWSController generates a signed URL according to http://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html and returns it using a JSON hash.
3. [Client] The `uploadToS3` function (defined in `app/assets/javascripts/cors.js`), takes the signed URL and the file, and PUTs the file onto S3. 
4. [Client] Once the upload is finished, the URL of the uploaded file is appended to the form as a hidden field.
5. [Client] When the user submits the form, the file field is removed (to avoid uploading the file again). Name, price and the file URL are POSTed to the server. 
6. [Server] A new product record is created.  

The most important files are are:

- `app/helpers/aws_helper` - Builds the AWS authentication signature as described in http://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html. It required the Amazon keys, as well as options about the request (request type, resource, etc).
- `app/controllers/aws_controller` - Given a filename and content type, returns a JSON of the form:
    
    ```JSON
    {
      "put_url": "The *signed* URL that must be used to make the request from the client side]",
      "file_url": "The url the file will be uploaded to. A random number is appended to the file name to avoid name collisions."
    }
    ```
- `app/assets/javascripts/cors.js` - Performs the actual upload using an XMLHttpRequest. Required the signed URL, and the file to perform the request.
- `app/assets/javascripts/products.js` - Handles UI callbacks, such as updating the progress bar. Also handles the file-upload callback. When the user chooses a file, the server is contacted to generate a signed URL, which is then passed to the CORS script described above to complete the upload.

