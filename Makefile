.DEFAULT_GOAL := up
VAGRANTFILE_EXTENSION := $(shell [ `uname -m` = "arm64" ] && echo "macm1" || echo "x64")

up:
	VAGRANT_VAGRANTFILE=Vagrantfile.$(VAGRANTFILE_EXTENSION) vagrant up

destroy:
	VAGRANT_VAGRANTFILE=Vagrantfile.$(VAGRANTFILE_EXTENSION) vagrant destroy f3-interview

ssh:
	VAGRANT_VAGRANTFILE=Vagrantfile.$(VAGRANTFILE_EXTENSION) vagrant ssh f3-interview