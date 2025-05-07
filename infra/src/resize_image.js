const AWS = require('aws-sdk');
const sharp = require('sharp');
const s3 = new AWS.S3();
const sns = new AWS.SNS();

exports.handler = async (event) => {
  // Get the bucket and key from the event
  const sourceBucket = event.Records[0].s3.bucket.name;
  const key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
  
  // Skip processing if the file is not an image
  if (!key.match(/\.(jpg|jpeg|png|gif)$/i)) {
    console.log('Not an image file, skipping processing');
    return;
  }
  
  // Get environment variables
  const destinationBucket = process.env.DESTINATION_BUCKET;
  const topicArn = process.env.SNS_TOPIC_ARN;
  const width = parseInt(process.env.RESIZE_WIDTH || 800);
  
  try {
    // Get the image from S3
    const s3Object = await s3.getObject({
      Bucket: sourceBucket,
      Key: key
    }).promise();
    
    // Resize the image
    const resizedImage = await sharp(s3Object.Body)
      .resize(width)
      .toBuffer();
    
    // Upload the resized image to the destination bucket
    await s3.putObject({
      Bucket: destinationBucket,
      Key: key,
      Body: resizedImage,
      ContentType: s3Object.ContentType
    }).promise();
    
    // Send a notification
    await sns.publish({
      TopicArn: topicArn,
      Subject: 'Image Resized Successfully',
      Message: `The image ${key} has been successfully resized and saved to ${destinationBucket}.`
    }).promise();
    
    console.log(`Successfully resized ${key} and uploaded to ${destinationBucket}`);
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