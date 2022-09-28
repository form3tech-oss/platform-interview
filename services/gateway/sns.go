package main

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sns"
	"github.com/cenkalti/backoff/v3"
	"math/rand"
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
		fmt.Printf("dialing %s\n", address)
		c, err := net.DialTimeout("tcp", address, 2*time.Second)
		if err != nil {
			fmt.Printf("error dialing %s %v\n", address, err)
			return err
		}
		fmt.Printf("dialed %s\n", address)

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
		Endpoint:         aws.String(snsEndpoint.String()),
	})

	if err != nil {
		return fmt.Errorf("could not create session. %w", err)
	}

	client := sns.New(sess)

	for range time.NewTicker(time.Second * 5).C {
		_, err := client.Publish(&sns.PublishInput{
			TopicArn: aws.String(snsTopicArn),
			Message:  aws.String(fmt.Sprintf("payment %d", rand.Int())),
		})
		if err != nil {
			return fmt.Errorf("publish payment on %s: %w", snsTopicArn, err)
		}
		fmt.Println("message sent")
	}

	return nil
}
