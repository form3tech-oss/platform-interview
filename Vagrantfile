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

  os=`uname`.strip()
  if os == "Darwin"
    arch = `arch`.strip()
    if arch == 'arm64' || (arch == 'i386' && running_rosetta()) # is M1
      config.vm.box = "multipass"
    end
  elsif os == "Linux"
    config.vm.box = "ubuntu/focal64"
    config.vm.provider "libvirt" do |libvirt|
      unless Vagrant.has_plugin?("vagrant-libvirt")
        raise 'vagrant-libvirt is not installed, you can install with (vagrant plugin install vagrant-libvirt)'
      end
      unless Vagrant.has_plugin?("vagrant-mutate")
        raise 'vagrant-mutate is not installed, you can install with (vagrant plugin install vagrant-mutate)'
      end
      config.vm.box = "generic/ubuntu2004"
    end
  end

  config.vm.provider "multipass" do |multipass, override|
    multipass.hd_size = "10G"
    multipass.cpu_count = 1
    multipass.memory_mb = 2048
    multipass.image_name = "bionic"
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
