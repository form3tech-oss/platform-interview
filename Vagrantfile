# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provision "docker" do |d|
      d.run   "vault",
        args: "--cap-add=IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=f23612cf-824d-4206-9e94-e31a6dc8ee8d' -p 8200:8200 --name=dev-vault"
      d.run   "vault",
        args: "--cap-add=IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=f23612cf-824d-4206-9e94-e31a6dc8ee8d' -p 8200:8300 --name=prod-vault"
    end

  config.vm.provision :shell,
    keep_color: true,
    privileged: false,
    run: "always",
    inline: $install_tools
end

$install_tools = <<SCRIPT
echo Installing docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo Installing terraform onto machine...
mkdir -p $HOME/bin
sudo apt-get update && sudo apt-get install -y unzip jq
pushd $HOME/bin
wget -q https://releases.hashicorp.com/terraform/1.0.7/terraform_1.0.7_linux_amd64.zip
unzip -q -o terraform_1.0.7_linux_amd64.zip
popd
docker ps

echo Applying terraform script
pushd /vagrant/tf
terraform apply -auto-approve
popd

set -x
SCRIPT