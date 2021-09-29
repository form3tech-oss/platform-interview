# platform-interview
Form3 Platform Interview


## Running the sample application
- make sure you have [vagrant](https://www.vagrantup.com/downloads) installed
- `vagrant up`

Once these steps have been followed you should see something like this in your terminal:

````
    default: vault_mount.transit: Creating...
    default: vault_audit.audit: Creating...
    default: vault_audit.audit: Creation complete after 0s [id=file]
    default: vault_mount.transit: Creation complete after 0s [id=transit]
    default: vault_transit_secret_backend_key.key: Creating...
    default: vault_transit_secret_backend_key.key: Creation complete after 0s [id=transit/keys/my_key]
    default: 
    default: Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
    default: 
    default: ~
    default: ++ base64 --decode
    default: ++++ base64
    default: +++ vault write -field=ciphertext transit/encrypt/my-key plaintext=bXkgc2VjcmV0IGRhdGEK
    default: ++ vault write -field=plaintext transit/decrypt/my-key ciphertext=vault:v1:EWkVqN9uLUAKZssciiFRAMIBs486LTFgCXpu0oNxSeEbEPalL1SJBe8LCA==
    default: my secret data
```


vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
     format=pem_bundle ttl="43800h" \
     | jq -r '.data.certificate' > intermediate.cert.pem