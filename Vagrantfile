# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "multipass"
  config.vm.hostname = "platform-interview"
  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"
  config.vm.provider "multipass" do |multipass, override|
        multipass.hd_size = "10G"
        multipass.cpu_count = 1
        multipass.memory_mb = 2048
        multipass.image_name = "bionic"
  end
  config.vm.provision :docker

  config.vm.provision :shell,
    keep_color: true,
    privileged: false,
    run: "always",
    inline: $install_tools
end

$install_tools = <<SCRIPT
ARCH=$(dpkg --print-architecture)
echo Installing terraform onto machine...
mkdir -p $HOME/bin
sudo apt-get update && sudo apt-get install -y unzip jq
pushd $HOME/bin
wget -q https://releases.hashicorp.com/terraform/1.2.5/terraform_1.2.5_linux_${ARCH}.zip
unzip -q -o terraform_1.2.5_linux_${ARCH}.zip
popd

echo Install tflocal
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
sudo apt install python3-pip -y
sudo apt install python-pip -y
pip install localstack-client
pip install terraform-local
. ~/.profile

pushd /vagrant
docker build ./services/account -t form3tech-oss/platformtest-account
docker build ./services/gateway -t form3tech-oss/platformtest-gateway
docker build ./services/payment -t form3tech-oss/platformtest-payment
docker compose up -d
popd
echo Applying terraform script
pushd /vagrant/tf
tflocal init -upgrade
tflocal apply -auto-approve
popd

set -x
SCRIPT