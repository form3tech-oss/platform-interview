package main

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sqs"
	"github.com/cenkalti/backoff/v3"
	"net"
	"net/url"
	"os"
)

func readPayments() error {
	queueURL := os.Getenv("QUEUE_URL")
	awsRegion := os.Getenv("AWS_REGION")
	awsAccessKeyId := os.Getenv("AWS_ACCESS_KEY_ID")
	awsAccessSecretAccessKey := os.Getenv("AWS_SECRET_ACCESS_KEY")
	sqsEndpoint, err := url.Parse(os.Getenv("SQS_ENDPOINT"))

	address := fmt.Sprintf("%s:%s", sqsEndpoint.Hostname(), sqsEndpoint.Port())
	operation := func() error {

		c, err := net.Dial("tcp", address)
		if err != nil {
			fmt.Printf("error dialing %s %v\n", address, err)
			return err
		}

		return c.Close()
	}

	err = backoff.Retry(operation, backoff.NewExponentialBackOff())
	if err != nil {
		return err
	}

	// Initialize a session
	sess, err := session.NewSession(&aws.Config{
		Region:           aws.String(awsRegion),
		Credentials:      credentials.NewStaticCredentials(awsAccessKeyId, awsAccessSecretAccessKey, ""),
		S3ForcePathStyle: aws.Bool(true),
		Endpoint:         aws.String(sqsEndpoint.String()),
	})

	if err != nil {
		return fmt.Errorf("could not create session. %w", err)
	}

	client := sqs.New(sess)

	for {
		res, err := client.ReceiveMessage(&sqs.ReceiveMessageInput{
			QueueUrl:              aws.String(queueURL),
			MaxNumberOfMessages:   aws.Int64(1),
			WaitTimeSeconds:       aws.Int64(20),
			MessageAttributeNames: aws.StringSlice([]string{"All"}),
		})
		if err != nil {
			return fmt.Errorf("receive on %s: %w", queueURL, err)
		}

		if len(res.Messages) > 0 {
			fmt.Printf("%d messages received\n", len(res.Messages))

			_, err = client.DeleteMessage(&sqs.DeleteMessageInput{
				QueueUrl:      aws.String(queueURL),
				ReceiptHandle: res.Messages[0].ReceiptHandle,
			})
			if err != nil {
				return fmt.Errorf("delete: %w", err)
			}
		} else {
			fmt.Printf("no messages\n")
		}
	}

}
