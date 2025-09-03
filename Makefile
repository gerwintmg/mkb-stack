bootstrap:
	sh scripts/host-setup.sh
	sh scripts/bootstrap.sh

ping:
	sh scripts/check-ansible.sh

apply:
	ansible-playbook -i ansible/inventories/hosts.yml ansible/site.yml

manual:
	sh scripts/generate-manual.sh
