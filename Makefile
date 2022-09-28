instance := platform-interview

.PHONY: launch
launch:
	multipass launch --cpus 4 --mem 2G --cloud-init userdata.yml --name $(instance)
	multipass mount $(CURDIR)/ $(instance):/home/ubuntu/code --uid-map $(shell id -u):1000 --gid-map $(shell id -g):1001
	multipass exec platform-interview /home/ubuntu/code/scripts/run.sh

.PHONY: shell
shell:
	multipass shell $(instance)

.PHONY: clean
clean:
	multipass delete -p $(instance) 2>/dev/null; true