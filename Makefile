.DEFAULT_GOAL := up

setup:
	@if [ `uname -m` = "arm64" ]; then\
        cp Vagrantfile.macm1 Vagrantfile;\
     else\
     	cp Vagrantfile.x64 Vagrantfile; \
    fi

up: setup
	vagrant up

destroy:
	vagrant destroy platform-interview-standbox