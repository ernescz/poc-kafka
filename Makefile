## START help: Help output for what each target does (add a '## <help text here>' after each target to enable)
RED=\033[0;31m
GRN=\033[0;32m
CYN=\033[0;36m
NC=\033[0m

.PHONY: help
.DEFAULT_GOAL := help

help: ## Print this help
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}'
## END help

check_requirements: 	## Checks for system compatibility (vagrant version, networking)
	$(eval VAGRANT_VERSION := $(shell vagrant version | grep -i installed | awk '{print $$3}'))
	@if [ "${VAGRANT_VERSION}" == "2.2.7" ]; then \
		echo "${GRN}[OK]${NC} vagrant version = 2.2.7" ; \
	else \
		echo "${RED}[FAIL]${NC} could not find vagrant with version 2.2.7. \n \
		Current version: ${VAGRANT_VERSION} \nPlease setup version 2.2.7" ; \
	fi 

	$(eval ANSIBLE_VERSION := $(shell ansible --version | grep -E "ansible\ 2\." | cut -f2 -d" " | cut -f1 -f2 -d"."))
	@if [ "${ANSIBLE_VERSION}" == "2.9" ]; then \
		echo "${GRN}[OK]${NC} Ansible version = ${ANSIBLE_VERSION}" ; \
	else \
		echo "${RED}[FAIL]${NC} Ansible version 2.9.x required \n \
		Current version: ${ANSIBLE_VERSION} -> Untested on other versions, unexpected results possible." ; \
	fi 

	$(eval VBOX_VERSION := $(shell VBoxManage --version | cut -c 1-3))
	@if [ "${VBOX_VERSION}" == "6.1" ]; then \
		echo "${GRN}[OK]${NC} virtualbox version = ${VBOX_VERSION}" ; \
	else \
		echo "${RED}[FAIL]${NC} virtualbox version 6.1 required \n \
		Current version: ${VBOX_VERSION} -> Please note Vagrant v2.2.6 does not support virtualbox v6.1" ; \
	fi 

	$(eval NET_ACCESS := $(shell curl -s -f -I  https://dl.fedoraproject.org/pub/epel > /dev/null; echo $$?))
	@if [ "${NET_ACCESS}" == "0" ]; then \
		echo "${GRN}[OK]${NC} EPEL repository reachable" ; \
	else \
		echo "${RED}[FAIL]${NC} could not connect to EPEL repository\n \
		Please make sure network is reachable"; \
	fi 

install_addons: ## Installs addons for vbox
	@vagrant plugin install vagrant-vbguest
	
create:		## Creates machines and runs full ansible deploy
	@echo "${GRN}Launching vagrant...${NC}" 
	@vagrant up 
	@echo "${GRN}Checking ansible access to hosts...${NC}" 
	@ansible -i ansible/inventory/hosts.yaml all -m ping
	@echo "${GRN}Running full deploy...${NC}" 
	@ansible-playbook -i ansible/inventory/hosts.yaml ansible/deploy.yaml --diff -v

destroy:		## Destroys all created machines
	@echo "${RED}Destorying the whole setup...${NC}" 
	@vagrant destroy --parallel
	@echo "${GRN}Completed. Run 'make create' to recreate again.${NC}" 
