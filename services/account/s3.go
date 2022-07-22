package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/cenkalti/backoff/v3"
	"net"
	"net/url"
	"os"
	"strings"
	"time"
)

func logStartup() error {
	environment := os.Getenv("ENVIRONMENT")
	bucket := os.Getenv("BUCKET_NAME")
	awsRegion := os.Getenv("AWS_REGION")
	awsAccessKeyId := os.Getenv("AWS_ACCESS_KEY_ID")
	awsAccessSecretAccessKey := os.Getenv("AWS_SECRET_ACCESS_KEY")
	s3endpoint, err := url.Parse(os.Getenv("S3_ENDPOINT"))

	if err != nil {
		return fmt.Errorf("could not parse uri. %w", err)
	}

	address := fmt.Sprintf("%s:%s", s3endpoint.Hostname(), s3endpoint.Port())
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
	sess, _ := session.NewSession(&aws.Config{
		Region:           aws.String(awsRegion),
		Credentials:      credentials.NewStaticCredentials(awsAccessKeyId, awsAccessSecretAccessKey, ""),
		S3ForcePathStyle: aws.Bool(true),
		Endpoint:         aws.String(s3endpoint.String()),
	})

	svc := s3.New(sess)
	ctx, _ := context.WithTimeout(context.Background(), time.Second*10)

	putResponse, err := svc.PutObjectWithContext(ctx, &s3.PutObjectInput{
		Bucket: aws.String(bucket),
		Key:    aws.String("account-start"),
		Body:   strings.NewReader("account api started..."),
	})

	if err != nil {
		return fmt.Errorf("failed to logStartup file to s3, %v %v", err, putResponse)
	}

	fmt.Printf("written file version: %v in %s", putResponse, environment)

	return nil
}
