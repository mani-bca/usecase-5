// Include dependencies directly in the package
const AWS = require('aws-sdk');
const sharp = require('sharp');
const s3 = new AWS.S3();
const sns = new AWS.SNS();

exports.handler = async (event) => {
  console.log('Event received:', JSON.stringify(event, null, 2));
  
  try {
    // Get the bucket and key from the event
    const sourceBucket = event.Records[0].s3.bucket.name;
    const key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
    
    console.log(`Processing image: ${key} from bucket: ${sourceBucket}`);
    
    // Skip processing if the file is not an image
    if (!key.match(/\.(jpg|jpeg|png|gif)$/i)) {
      console.log('Not an image file, skipping processing');
      return {
        statusCode: 200,
        body: JSON.stringify({ message: 'Not an image file, skipping processing' })
      };
    }
    
    // Get environment variables
    const destinationBucket = process.env.DESTINATION_BUCKET;
    const topicArn = process.env.SNS_TOPIC_ARN;
    const width = parseInt(process.env.RESIZE_WIDTH || 800);
    
    console.log(`Destination bucket: ${destinationBucket}, SNS topic: ${topicArn}, Width: ${width}`);
    
    // Get the image from S3
    console.log(`Getting image from S3: ${sourceBucket}/${key}`);
    const s3Object = await s3.getObject({
      Bucket: sourceBucket,
      Key: key
    }).promise();
    
    console.log(`Image downloaded successfully, size: ${s3Object.Body.length} bytes`);
    
    // Resize the image
    console.log(`Resizing image to width: ${width}px`);
    const resizedImage = await sharp(s3Object.Body)
      .resize(width)
      .toBuffer();
    
    console.log(`Image resized successfully, new size: ${resizedImage.length} bytes`);
    
    // Upload the resized image to the destination bucket
    console.log(`Uploading resized image to: ${destinationBucket}/${key}`);
    await s3.putObject({
      Bucket: destinationBucket,
      Key: key,
      Body: resizedImage,
      ContentType: s3Object.ContentType
    }).promise();
    
    console.log('Image uploaded successfully');
    
    // Send a notification
    console.log(`Sending notification to SNS topic: ${topicArn}`);
    await sns.publish({
      TopicArn: topicArn,
      Subject: 'Image Resized Successfully',
      Message: `The image ${key} has been successfully resized and saved to ${destinationBucket}.`
    }).promise();
    
    console.log('Notification sent successfully');
    
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: 'Image resized successfully',
        source: sourceBucket,
        destination: destinationBucket,
        key: key
      })
    };
  } catch (error) {
    console.error('Error processing image:', error);
    throw error;
  }
};