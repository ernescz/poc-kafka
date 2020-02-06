# Kafka (proof of concept)

**Kafka** streamping platform proof of concept setup with two applications (Producer and Consumer) that are publishing messages to Kafka's topics. The setup is monitored via Prometheus and Grafana. Application Producer is written in Golang but Consumer - using Python 3. This is to showcase different implementation and libs to work with Kafka. 
The setup monitoring contains two type of metrics - system metrics (e.g., memory usage) and application based metrics (number of messages consumed per second). Kafka's system metrics are exposed via JMX agent but application based metrics are gathered using statsd service. Working sample dashboards are added to Grafana for ease of use. <br>
All of the software setup is done with Ansible and requires no manual intervention. Base OS for the setup is CentOS 7.x and it is provisioned using Vagrant and VirtualBox. A Makefile with appropriate targets is provided to speed up the setup. 

## Requirements
This setup has several requirements and has been tested with exactly these versions. Newer or older versions might, might not work. <br>
- Vagrant (v2.2.7)
- VirtualBox (v6.1)
  - vagrant-vbguest (VirtualBox addon)
- ansible (v2.9.x)
- GNU make (v3.81+)

All of these must be available in shell's $PATH (e.g., `VBoxManage` for VirtualBox). 
Additionally, VirtualBox guest machines must be able to communicate with outside world to download soft/updates. Also, a host machine with at least 8GB of memory should be used (2.5GB is allocated to the guests). Makefile's `make check_requirements` does sanity check for the requirements mentioned above. 

## Setup
To do the setup, please:
* clone this repo;
* run `make check_requirements` in the base directory to see if requirements are satisfied;
* *(optional)* run `make install_addons` to install vbox addon for vagrant if not present;
* run `make create` to build Vagrant machines and apply ansible, no manual changes are necessary; in case you need to change something, please see ansible roles and default values there;
* when setup is no longer needed run `make destroy` which forces all machine full deletion, use with care
* Also, run `make` without targets to see all targets and their desription.

## Access
To access the final Grafana setup and see metrics/stats, open http://192.168.100.14:3000 and login with user `admin` and password `pocAdmin` *(edit `ansible/roles/grafana/defaults/main.yml` and change `grafana_gui_adm_pass` variable prior to deployment to set to another value)*
Prometheus dashboard is located at https://192.168.100.14:9090
statsd application metrics endpoint: https://192.168.100.12:9102
`kafka` host with Kafka/Zookeeper service;
`apps` host with Producer and Consumer applications;
`monitoring` with Grafana/Prometheus
 
## To-do and improvements
Setup is just a proof of concept and should not be treated otherwise. That said, there are already several improvements that should be made to the setup, e.g.,:
- Apps should take configs from files and not hard-coded values
- Network should be configurable via ansible's fact gathering
- Enable ansible vault for any sensitive data
- Create a CI for application build
- Create tests for build (e.g., TravisCI)
- Rewrite defaults/vars to include other vars (this was not possible in ansible 2.4 version)
- Refactor Prometheus locations/base directory to avoid silly naming scheme
- Drop `statsd` in favour of offical Prometheus libraries

