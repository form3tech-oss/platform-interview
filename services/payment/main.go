package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"
)

const SERVICE_NAME = "payment"
func main()  {
	fmt.Printf("%s service initializing....\n", SERVICE_NAME)
	err := readSecret()
	if err != nil {
		fmt.Println(err)
		exit(1)
	}

	fmt.Printf("%s service started....\n", SERVICE_NAME)

	sigs := make(chan os.Signal, 1)
	done := make(chan bool, 1)

	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		_ = <-sigs
		done <- true
	}()

	<-done
	exit(0)
}

func exit(status int)  {
	if status == 0 {
		fmt.Printf("%s service exit....\n", SERVICE_NAME)
	} else {
		fmt.Printf("%s  service with error code %d....\n", SERVICE_NAME, status)
	}
	os.Exit(status)
}