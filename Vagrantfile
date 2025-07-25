# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  def running_rosetta()
    !`sysctl -in sysctl.proc_translated`.strip().to_i.zero?
  end

  arch = `arch`.strip()
  if arch == 'arm64' || (arch == 'i386' && running_rosetta()) # is M1
    config.vm.box = "multipass"
  else # not M1
    config.vm.box = "ubuntu/jammy64"
  end

  config.vm.provider "multipass" do |multipass, override|
    multipass.hd_size = "10G"
    multipass.cpu_count = 1
    multipass.memory_mb = 2048
    multipass.image_name = "22.04"
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
  config.vm.boot_timeout = 300

  config.vm.provision :shell,
    keep_color: true,
    privileged: false,
    run: "always",
    path: "./run.sh"
end
