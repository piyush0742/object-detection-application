import boto3
import json
import urllib.parse
 
s3 = boto3.client('s3')
rekognition = boto3.client('rekognition')
sns = boto3.client('sns')
 
def lambda_handler(event, context):
    try:
        # Process each SQS message
        for record in event['Records']:
            # Parse S3 event from SQS message
            s3_event = json.loads(record['body'])
            
            # Get bucket and key from S3 event
            bucket = s3_event['Records'][0]['s3']['bucket']['name']
            key = urllib.parse.unquote_plus(s3_event['Records'][0]['s3']['object']['key'])
            
            # Skip if not in /images folder
            if not key.startswith('images/'):
                continue
                
            # Call Rekognition
            response = rekognition.detect_labels(
                Image={'S3Object': {'Bucket': bucket, 'Name': key}},
                MaxLabels=10,
                MinConfidence=70
            )
            
            # Process results
            labels = [label['Name'] for label in response['Labels']]
            confidences = {label['Name']: label['Confidence'] for label in response['Labels']}
            
            # Your business logic (example: check for 'Dog')
            is_success = 'Dog' in labels and confidences.get('Dog', 0) >= 90
            
            # Move file to appropriate folder
            new_key = key.replace('images/', 'analysed/success/' if is_success else 'analysed/failure/')
            
            # Copy then delete original (S3 doesn't have move)
            s3.copy_object(
                Bucket=bucket,
                CopySource={'Bucket': bucket, 'Key': key},
                Key=new_key
            )
            s3.delete_object(Bucket=bucket, Key=key)
            
            # Send notification
            sns.publish(
                TopicArn='arn:aws:sns:us-east-2:637423586175:image-notification',
                Message=f"Image analysis complete: {key}\n" +
                       f"Success: {is_success}\n" +
                       f"Labels found: {', '.join(labels)}\n" +
                       f"Confidences: {confidences}",
                Subject=f"Image Analysis Result - {'SUCCESS' if is_success else 'FAILURE'}"
            )
            
        return {'statusCode': 200, 'body': json.dumps('Processing complete')}
    
    except Exception as e:
        print(f"Error: {str(e)}")
        raise e