package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"
)

const SERVICE_NAME = "gateway"

func main() {
	fmt.Printf("%s service initializing....\n", SERVICE_NAME)
	if err := readSecret(); err != nil {
		fmt.Printf("error reading vault secret: %v\n", err)
	} else {
		fmt.Printf("%s service started....\n", SERVICE_NAME)
	}

	go func() {
		if err := sendPayments(); err != nil {
			fmt.Printf("error logging startup %v\n", err)
			exit(1)
		}
	}()

	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	<-sigs
	exit(0)
}

func exit(status int) {
	if status == 0 {
		fmt.Printf("%s service exit....\n", SERVICE_NAME)
	} else {
		fmt.Printf("%s  service with error code %d....\n", SERVICE_NAME, status)
	}
	os.Exit(status)
}
