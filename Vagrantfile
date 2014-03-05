# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.

  config.vm.box = "wheezy64"
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", 2048]
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.options = ['--verbose']
  end
  
  config.vm.define "cassandra1" do |cassandra|
    cassandra.vm.network "private_network", ip: "192.168.1.10"
    cassandra.vm.host_name = "cassandra1"
  end

  config.vm.define "cassandra2" do |cassandra|
    cassandra.vm.network "private_network", ip: "192.168.1.11"
    cassandra.vm.host_name = "cassandra2"
  end

  config.vm.define "cassandra3" do |cassandra|
    cassandra.vm.network "private_network", ip: "192.168.1.12"
    cassandra.vm.host_name = "cassandra3"
  end
  
  config.vm.define "cassandra4" do |cassandra|
    cassandra.vm.network "private_network", ip: "192.168.1.13"
    cassandra.vm.host_name = "cassandra4"
  end
end
