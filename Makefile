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
	@if [ "${VAGRANT_VERSION}" == "2.2.6" ]; then \
		echo "${GRN}[OK]${NC} vagrant version = 2.2.6" ; \
	else \
		echo "${RED}[FAIL]${NC} could not find vagrant with version 2.2.6. \n \
		Current version: ${VAGRANT_VERSION} \nPlease setup version 2.2.6" ; \
	fi 

	$(eval NET_ACCESS := $(shell curl -s -f -I  https://dl.fedoraproject.org/pub/epel > /dev/null; echo $$?))
	@if [ "${NET_ACCESS}" == "0" ]; then \
		echo "${GRN}[OK]${NC} EPEL repository reachable" ; \
	else \
		echo "${RED}[FAIL]${NC} could not connect to EPEL repository\n \
		Please make sure network is reachable"; \
	fi 

	$(eval VBOX_VERSION := $(shell VBoxManage --version | cut -c 1-3))
	@if [ "${VBOX_VERSION}" == "6.0" ]; then \
		echo "${GRN}[OK]${NC} virtualbox version = ${VBOX_VERSION}" ; \
	else \
		echo "${RED}[FAIL]${NC} virtualbox version 6.0 required \n \
		Current version: ${VBOX_VERSION} -> Vagrant v2.2.6 does not support virtualbox v6.1" ; \
	fi 

install_addons: ## Installs addons for vbox
	@vagrant plugin install vagrant-vbguest
	
init:		## Deploys vagrant machines from the Vagrantfile
	@echo "${GRN}Launching vagrant...${NC}" 
	@vagrant up 

destroy:		## Destroys all created machines
	@echo "${RED}Destorying the whole setup...${NC}" 
	@vagrant destroy --parallel
	@echo "${GRN}Completed.${NC}" 
