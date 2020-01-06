##
## Vagrantfile deployment for the POC (see README for more info)
##
Vagrant.configure("2") do |config|

  # Create kafka node
  config.vm.define :kafka do |kafka_config|
      kafka_config.vm.box = "centos/7"
      kafka_config.vm.hostname = "kafka"
      kafka_config.vm.network :private_network, ip: "192.168.100.10"
      kafka_config.vm.network "forwarded_port", guest: 80, host: 8088
      # kafka_config.vm.synced_folder ".", "/vagrant", type: "rsync",
      #   rsync__exclude: ".git/"
      kafka_config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
      kafka_config.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
    end
    
      
#   # Create app node
#   config.vm.define :date_app do |date_app_config|
#     date_app_config.vm.box = "centos/7"
#     date_app_config.vm.hostname = "date-app"
#     date_app_config.vm.network :private_network, ip: "192.168.100.11"
#     date_app_config.vm.network "forwarded_port", guest: 80, host: 8088
#     date_app_config.vm.provider "virtualbox" do |vb|
#       vb.memory = "256"
#     end
# end

  # # Create monitoring node
  #   config.vm.define :monitoring do |monitoring_config|
  #     monitoring_config.vm.box = "ubuntu/xenial64"
  #     monitoring_config.vm.hostname = "monitoring"
  #     monitoring_config.vm.network :private_network, ip: "192.168.100.21"
  #     monitoring_config.vm.network "forwarded_port", guest: 81, host: 8081
  #     monitoring_config.vm.provider "virtualbox" do |vb|
  #         vb.memory = "256"
  #       end
  #   end
end
