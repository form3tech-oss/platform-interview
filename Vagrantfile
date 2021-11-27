# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provision :docker

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
. ~/.profile
popd
pushd /vagrant
docker build ./services/account -t form3tech-oss/platformtest-account
docker build ./services/gateway -t form3tech-oss/platformtest-gateway
docker build ./services/payment -t form3tech-oss/platformtest-payment
docker-compose up -d
popd
echo Applying terraform script
pushd /vagrant/tf
terraform init -upgrade
terraform apply -auto-approve
popd

set -x
SCRIPT