# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
	config.vm.box = "ubuntu/trusty64"
	config.vm.box_check_update = false
	config.vm.network "forwarded_port", guest: 80, host: 8080
	config.vm.network "forwarded_port", guest: 3000, host: 3000
	config.vm.network "forwarded_port", guest: 4000, host: 4000 
	config.vm.provision :shell, path: "bootstrap.sh"

	config.vm.provider "virtualbox" do |vb|
		vb.name = "webdev_v0.0.1"
		# do not start VirtuaBox GUI when running this Vagrant
		vb.gui = false
		# memory must be 1024, otherwise meteor+mongodb will not start
		vb.memory = "1024"
		# maybe a fix for shared folders / mongodb issue
		vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
	end

end