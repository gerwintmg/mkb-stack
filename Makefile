bootstrap:
	bash scripts/host-setup.sh
	bash scripts/bootstrap.sh

ping:
	bash scripts/check-ansible.sh

apply:
	ansible-playbook -i ansible/inventories/hosts.yml ansible/site.yml

manual:
	bash scripts/generate-manual.sh
