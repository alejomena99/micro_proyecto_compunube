# -*- mode: ruby -*-
# vi: set ft=ruby :

$install_puppet = <<-PUPPET
sudo apt-get update -y
sudo apt-get install -y puppet
PUPPET

Vagrant.configure("2") do |config|

    if Vagrant.has_plugin? "vagrant-vbguest"
      config.vbguest.no_install  = true
      config.vbguest.auto_update = false
      config.vbguest.no_remote   = true
    end

    config.vm.define :clientProject do |clientProject|
      clientProject.vm.box = "bento/ubuntu-22.04"
      clientProject.vm.network :private_network, ip: "193.168.100.5"
      clientProject.vm.hostname = "clientProject"
      clientProject.vm.boot_timeout = 800

      clientProject.vm.provision "shell", inline: <<-SHELL
        echo 'export private_ip=193.168.100.5' >> /home/vagrant/.bashrc
      SHELL

      clientProject.vm.provision "shell", inline: $install_puppet
      clientProject.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file = "client.pp"
        puppet.module_path = "puppet/modules"
        puppet.facter = {
          "private_ip" => "193.168.100.5",
        }
      end
    end

    config.vm.define :webProject1 do |webProject1|
      webProject1.vm.box = "bento/ubuntu-22.04"
      webProject1.vm.network :private_network, ip: "193.168.100.3"
      webProject1.vm.hostname = "webProject1"
      webProject1.vm.boot_timeout = 800
      webProject1.vm.synced_folder "D:/Vagrant/synchronized_folder_web1", "/home/vagrant/synchronized_folder_web1"

      webProject1.vm.provision "shell", inline: <<-SHELL
        echo 'export private_ip=193.168.100.3' >> /home/vagrant/.bashrc
        echo 'export microservice_name=my_microservice' >> /home/vagrant/.bashrc
        echo 'export consul_ip=193.168.100.5' >> /home/vagrant/.bashrc
        echo 'export service_id=web1' >> /home/vagrant/.bashrc
      SHELL
  
      webProject1.vm.provision "shell", inline: $install_puppet
      webProject1.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file = "web.pp"
        puppet.module_path = "puppet/modules"
        puppet.facter = {
          "private_ip" => "193.168.100.3",
          "microservice_name" => "my_microservice",
          "consul_ip" => "193.168.100.5",
          "service_id" => "web1"
        }
      end
    end

    config.vm.define :webProject2 do |webProject2|
      webProject2.vm.box = "bento/ubuntu-22.04"
      webProject2.vm.network :private_network, ip: "193.168.100.4"
      webProject2.vm.hostname = "webProject2"
      webProject2.vm.boot_timeout = 800
      webProject2.vm.synced_folder "D:/Vagrant/synchronized_folder_web2", "/home/vagrant/synchronized_folder_web2"

      webProject2.vm.provision "shell", inline: <<-SHELL
        echo 'export private_ip=193.168.100.4' >> /home/vagrant/.bashrc
        echo 'export microservice_name=my_microservice' >> /home/vagrant/.bashrc
        echo 'export consul_ip=193.168.100.5' >> /home/vagrant/.bashrc
        echo 'export service_id=web2' >> /home/vagrant/.bashrc
      SHELL

      webProject2.vm.provision "shell", inline: $install_puppet
      webProject2.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file = "web.pp"
        puppet.module_path = "puppet/modules"
        puppet.facter = {
          "private_ip" => "193.168.100.4",
          "microservice_name" => "my_microservice",
          "consul_ip" => "193.168.100.5",
          "service_id" => "web2"
        }
      end
    end

    config.vm.define :balancerProject do |balancerProject|
      balancerProject.vm.box = "bento/ubuntu-22.04"
      balancerProject.vm.network :private_network, ip: "193.168.100.6"
      balancerProject.vm.hostname = "balancerProject"
      balancerProject.vm.boot_timeout = 800

      balancerProject.vm.provision "shell", inline: <<-SHELL
        echo 'export private_ip=193.168.100.6' >> /home/vagrant/.bashrc
      SHELL

      balancerProject.vm.provision "shell", inline: $install_puppet
      balancerProject.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file = "balancer.pp"
        puppet.module_path = "puppet/modules"
        puppet.facter = {
          "private_ip" => "193.168.100.6",
        }
      end
    end

end
  