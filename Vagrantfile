# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'securerandom'

# remove the 'client' entry to below to save on host resources
nodes = {
    'controller'  => [1, 200],
    'cinder' => [1, 201], # if ever change cinder IP, also change in controller.sh!
    'quantum' => [1, 202],
    'compute'  => [2, 211],
    'client' => [1, 100]
    # , 'graphite' => [1, 101]
}

# This is some magic to help avoid network collisions.
# If however, it still collides, or if you need to vagrant up machines one at a time, comment out this line and uncomment the one below it
third_octet = 80

Vagrant.configure("2") do |config|
  # We assume virtualbox, if using Fusion, you'll want to change this as needed
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  #VMware Fusion\Workstation Users: Comment the line above and uncomment the appropriate line below
  #config.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"

  nodes.each do |prefix, (count, ip_start)|
    count.times do |i|
      hostname = (count == 1 ? prefix : prefix+"-#{i+1}")
        config.vm.define "#{hostname}" do |box|
          box.vm.hostname = "#{hostname}.stack.storm"
          box.vm.network :private_network, ip: "172.16.#{third_octet}.#{ip_start+i}", :netmask => "255.255.0.0"
          box.vm.network :private_network, ip: "10.10.#{third_octet}.#{ip_start+i}", :netmask => "255.255.0.0"
          box.vm.network :private_network, ip: "192.168.#{third_octet}.#{ip_start+i}", :netmask => "255.255.255.0"
          if prefix == "client"
            box.vm.network :forwarded_port, guest: 80, host: 8180
            box.vm.network :forwarded_port, guest: 9000, host: 8190
          end

          # Run the Shell Provisioning Script file
          box.vm.provision :shell, :path => "#{prefix}.sh"

          # If using VirtualBox
          box.vm.provider :virtualbox do |vbox|
	          # Defaults
            vbox.customize ["modifyvm", :id, "--memory", 1024]
            vbox.customize ["modifyvm", :id, "--cpus", 1]
            if prefix == "compute"
              vbox.customize ["modifyvm", :id, "--memory", 1024]
              vbox.customize ["modifyvm", :id, "--cpus", 2]
            elsif prefix == "controller"
              vbox.customize ["modifyvm", :id, "--memory", 1024]
            elsif prefix == "client"
              vbox.customize ["modifyvm", :id, "--memory", 512]
            end
          end  
        end
      end
    end
  end

