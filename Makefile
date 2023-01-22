new-env:
	@scripts/./create_new_env.sh

up:
	vagrant up

down:
	vagrant destroy

reload:
	vagrant reload --provision

ssh:
	vagrant ssh