package main

import (
	"encoding/json"
	"fmt"
	"github.com/hashicorp/vault/api"
	"os"
)

func readSecret() error {
	config := api.DefaultConfig()
	client, err := api.NewClient(config)

	if err != nil {
		return fmt.Errorf("error creating vault client: %v\n", err)
	}

	password := os.Getenv("VAULT_PASSWORD")
	userName := os.Getenv("VAULT_USERNAME")

	options := map[string]interface{}{
		"password": password,
	}
	path := fmt.Sprintf("/auth/userpass/login/%s", userName)

	secret, err := client.Logical().Write(path, options)
	if err != nil {
		return fmt.Errorf("error getting token with %v\n", err)
	}

	token := secret.Auth.ClientToken

	client.SetToken(token)

	environment := os.Getenv("ENVIRONMENT")
	data, err := client.Logical().Read(fmt.Sprintf("secret/data/%s/%s", environment, SERVICE_NAME))
	if err != nil {
		return fmt.Errorf("error reading secret: %v\n", err)
	}

	b, _ := json.Marshal(data.Data)
	fmt.Println(string(b))

	return nil
}


