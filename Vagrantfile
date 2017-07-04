=begin
clusters = {
						"webservers" => {
															:box        => "centos/7",
															:box_url    => "https://atlas.hashicorp.com/centos/boxes/7",
															:hostname   => "apache",
															:private_ip => "192.168.100.10",
															:port       => 80,
															:memory     => 1024,
															:cpus       => 1,
						},
						"dbservers" => {
														:box         => "centos/7",
														:box_url     => "https://atlas.hashicorp.com/centos/boxes/7",
														:hostname    => "maria",
														:private_ip_ => "192.168.100.20",
														:port        => 3306,
														:memory      => 1024,
														:cpus        => 1,
						},
}
=end

Vagrant.configure("2") do |config|
	(0..1).each do |i|
		config.vm.define "apache#{i}" do |node|
			node.vm.box = "centos/7"
		  node.vm.box_url = "https://atlas.hashicorp.com/centos/boxes/7"
		  node.vm.hostname = "apache#{i}"
		  node.vm.network "forwarded_port", guest: 80, host: 8080 + i
		  node.vm.network "private_network", ip: "192.168.100.#{10 + i}"
		  node.vm.network "public_network", bridge:"wlp3s0", use_dhcp_assigned_default_route: true
		  config.vm.provider "virtualbox" do |vb|
		    vb.memory = 1024
		    vb.cpus = 1
			end
		end
	end

	(0..1).each do |i|
		config.vm.define "maria#{i}" do |node|
		  node.vm.box = "centos/7"
	    node.vm.box_url = "https://atlas.hashicorp.com/centos/boxes/7"
	    node.vm.hostname = "maria#{i}"
	    node.vm.network "forwarded_port", guest: 3306, host: 11306 + i
	    node.vm.network "private_network", ip: "192.168.100.#{20 + i}"
	    node.vm.network "public_network", bridge:"wlp3s0", use_dhcp_assigned_default_route: true
	    config.vm.provider "virtualbox" do |vb|
	      vb.memory = 1024
	      vb.cpus = 1
	    end
		end
	end
	
	config.vm.provision :ansible do |ansible|
		ansible.limit = "all"
		#ansible.inventory_path = "/etc/ansible/hosts"
		ansible.groups = {
			"webservers" => ["apache[0:1]"],
			"dbservers"  => ["maria[0:1]"],
		}
		ansible.raw_arguments = ["--extra-vars='ansible_become_pass=vagrant'"]
		ansible.playbook = "provisioning/site.yml" 
	end
end

