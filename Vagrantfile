##
## Vagrantfile deployment for the POC (see README for more info)
##
Vagrant.configure("2") do |config|

  # Kafka node:
  config.vm.define :kafka do |kafka_config|
    kafka_config.vm.box = "centos/7"
    kafka_config.vm.hostname = "kafka"
    kafka_config.vm.network :private_network, ip: "192.168.100.10"
    # kafka_config.vm.network "forwarded_port", guest: 80, host: 8088
    kafka_config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    kafka_config.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
    end
  end
    
  # Applications node:
  config.vm.define :apps do |apps_config|
    apps_config.vm.box = "centos/7"
    apps_config.vm.hostname = "apps"
    apps_config.vm.network :private_network, ip: "192.168.100.12"
    # apps_config.vm.network "forwarded_port", guest: 80, host: 8089
    apps_config.vm.provider "virtualbox" do |vb|
      vb.memory = "768"
    end
  end
  
  # Monitoring node:
  config.vm.define :monitoring do |monitoring_config|
    monitoring_config.vm.box = "centos/7"
    monitoring_config.vm.hostname = "monitoring"
    monitoring_config.vm.network :private_network, ip: "192.168.100.14"
    # monitoring_config.vm.network "forwarded_port", guest: 80, host: 8090
    monitoring_config.vm.provider "virtualbox" do |vb|
      vb.memory = "768"
    end
  end

end
