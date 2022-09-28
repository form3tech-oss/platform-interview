package main

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sns"
	"github.com/cenkalti/backoff/v3"
	"time"

	"net"
	"net/url"
	"os"
)

func sendPayments() error {
	awsRegion := os.Getenv("AWS_REGION")
	awsAccessKeyId := os.Getenv("AWS_ACCESS_KEY_ID")
	awsAccessSecretAccessKey := os.Getenv("AWS_SECRET_ACCESS_KEY")
	snsTopicArn := os.Getenv("SNS_TOPIC_ARN")
	snsEndpoint, err := url.Parse(os.Getenv("SNS_ENDPOINT"))

	address := fmt.Sprintf("%s:%s", snsEndpoint.Hostname(), snsEndpoint.Port())

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

	fmt.Printf("about to create session")

	// Initialize a session
	sess, err := session.NewSession(&aws.Config{
		Region:           aws.String(awsRegion),
		Credentials:      credentials.NewStaticCredentials(awsAccessKeyId, awsAccessSecretAccessKey, ""),
		S3ForcePathStyle: aws.Bool(true),
		Endpoint:         aws.String(snsEndpoint.String()),
	})

	if err != nil {
		return fmt.Errorf("could not create session. %w", err)
	}

	fmt.Printf("session created")

	client := sns.New(sess)

	paymentNumber := 0
	for range time.NewTicker(time.Second * 1).C {
		fmt.Printf("before publish")
		res, err := client.Publish(&sns.PublishInput{
			TopicArn: aws.String(snsTopicArn),
			Message:  aws.String(fmt.Sprintf("payment %d", paymentNumber)),
		})
		if err != nil {
			return fmt.Errorf("publish payment on %s: %w", snsTopicArn, err)
		}

		fmt.Printf("published message %s", *res.MessageId)

		paymentNumber = paymentNumber + 1
	}

	return nil
}
