# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # Tells us if the host system is an Apple Silicon Mac running Rosetta
  def running_rosetta()
    !`sysctl -in sysctl.proc_translated`.strip().to_i.zero?
  end

  arch = `arch`.strip()
  if arch == 'arm64' || (arch == 'i386' && running_rosetta()) # is M1
    config.vm.box = "multipass"
  else # not M1
    #config.vm.box = "ubuntu/bionic64"
    #using vagrant image which works with VMware Fusion on Macbook Pro 2015
    config.vm.box = "hashicorp/bionic64"
    #Possible other vagrant/ubuntu images to test with VMware Fusion on Mac
    #config.vm.box = "generic/ubuntu1804"
  end

  #Configure Mem/CPU for the multipass VM
#   config.vm.provider "multipass" do |multipass, override|
#     multipass.hd_size = "10G"
#     multipass.cpu_count = 1
#     multipass.memory_mb = 2048
#     multipass.image_name = "bionic"
#   end

#Configure Mem/CPU for the VMWare VM
  config.vm.provider "vmware_desktop" do |vmware|
    vmware.linked_clone = true
    vmware.gui = false
    vmware.vmx["memsize"] = "2048"
    vmware.vmx["numvcpus"] = "2"
  end

  config.vm.provision "file", source: "./form3.crt", destination: "/tmp/form3.crt"
  config.vm.provision :shell,
                      keep_color: true,
                      privileged: false,
                      run: "always",
                      inline: <<-SCRIPT
    sudo mv /tmp/form3.crt /usr/local/share/ca-certificates/form3_ca.crt
    sudo update-ca-certificates
    sudo ip link set dev $(ip a|grep -E "^[0-9]*:" | grep -v LOOPBACK|awk -F: '{print $2}' |grep -v docker) mtu 1024
  SCRIPT

  config.vm.provision :docker
  config.vm.define "f3-interview"
  config.vm.hostname = "f3-interview"
  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"

  config.vm.provision :shell,
    keep_color: true,
    privileged: false,
    run: "always",
    path: "./run.sh"
end
