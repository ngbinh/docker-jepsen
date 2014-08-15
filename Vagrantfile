# -*- mode: ruby -*-
# vi: set ft=ruby :

# Using Vagrant shell scripts
# https://github.com/StanAngeloff/vagrant-shell-scripts
require File.join(File.dirname(__FILE__), 'scripts/vagrant-shell-scripts/vagrant')
  
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 1.6.0"

# the domain of all the nodes
DOMAIN = 'local'

# Docker-friendly Ubuntu 14.04 box at https://vagrantcloud.com/phusion/ubuntu-14.04-amd64
BOX = 'phusion/ubuntu-14.04-amd64'

# define all the nodes here.
# :host is the id in Vagrant of the node. It will also be its hostname
# :ip the ip address of the node
# :cpu the number of core for the node
# :ram the amount of RAM allocated to the node in MBytes.
NODES = [
  { :host => 'work-master', :ip => '192.168.2.10', :cpu => 2, :ram => '3072' },
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  NODES.each do | node |
    config.vm.define node[:host] do | node_config |
      node_config.vm.box = BOX
      node_config.vm.hostname = node[:host] + "." + DOMAIN
      node_config.vm.network :private_network, ip: node[:ip]

      # by default, the current folder is shared as /vagrant in the nodes
      # you can also share an outside folder here
      # node_config.vm.synced_folder "shared", "/shared"

      memory = node[:ram] ? node[:ram] : 1024
      cpu = node[:cpu] ? node[:cpu] : 1

      node_config.vm.provider :virtualbox do | vbox |
        vbox.gui = false
        vbox.customize ['modifyvm', :id, '--memory', memory.to_s]
        vbox.customize ['modifyvm', :id, '--cpus', cpu.to_s]

        # fix the connection slow
        # https://github.com/mitchellh/vagrant/issues/1807
        # vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        # vbox.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      end

      if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
        # Install Docker
        pkg_cmd = "wget -q -O - https://get.docker.io/gpg | apt-key add -;" \
        "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list;" \
        "apt-get update -qq; apt-get install -q -y --force-yes lxc-docker; "
        # Add vagrant user to the docker group
        pkg_cmd << "usermod -a -G docker vagrant; "
        config.vm.provision :shell, :inline => pkg_cmd
      end

      node_config.vm.provision :shell do |shell|
        vagrant_shell_scripts_configure(
        shell,
        File.dirname(__FILE__),
        'scripts/setup.sh')
      end
    end
  end
end