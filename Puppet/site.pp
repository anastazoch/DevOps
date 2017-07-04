case $osfamily {
    'RedHat': {
	$package_manager = 'yum'
    	if $osname == /(CentOS|RedHat)/ {
    	    case $facts['os']['release']['major'] {
            	'7':	 { $epel_url = 'https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm' }
		'6': 	 { $epel_url = 'https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm' }
		default: { }
    	    }
    	}
    } 'Debian': {
	$package_manager = 'apt'
    } default: {
	$package_manager = 'yum'
    }
}

node 'tomcat.corp.local' {
	include tomcat
	include selinux

	tomcat::install { '/opt/tomcat':
	  source_url => 'http://apache.forthnet.gr/tomcat/tomcat-9/v9.0.0.M21/bin/apache-tomcat-9.0.0.M21.tar.gz'
	}
	tomcat::instance { 'default':
	  catalina_home => '/opt/tomcat',
	}
	tomcat::config::server { 'tomcat':
	  catalina_base => '/opt/tomcat',
	  port          => '8005',
	}
	tomcat::config::server::connector { 'tomcat-http':
	  catalina_base         => '/opt/tomcat',
	  port                  => '8080',
	  protocol              => 'HTTP/1.1',
	  additional_attributes => {
   	    'redirectPort' => '8443'
	  },
	}
	tomcat::config::server::tomcat_users { 
	  'admin':
            catalina_base => '/opt/tomcat',
	    file          => '$CATALINA_BASE/conf/tomcat-users.xml',
	    element       => 'user',
	    element_name  => 'admin',
	    password      => 'tomcat',
	    roles         => [ 'manager-gui', 'admin-gui' ],
	    manage_file   => true,
	    ensure        => true,
	}

	file { 'tomcat.service':
  	  ensure  => file,
	  path    => '/etc/systemd/system/tomcat.service',
  	  content => template('tomcat/tomcat.service.erb'),
          # Loads /etc/puppetlabs/code/environments/production/modules/tomcat/templates/tomcat.service.erb
	}
	
	exec { 'daemon-reload':
	  command => 'systemctl daemon-reload',
	  path    => '/usr/bin', 
	}
	service { 'tomcat':
	  name     => 'tomcat.service',
	  provider => 'systemd',
	  ensure   => 'running',
	  enable   => true,
	}

}
/*
node 'apache.corp.local' {
	include ntp

	user { 'mitchell':
      	  ensure  => present,
	  name    => 'tomcat',
  	  groups  => 'tomcat',
  	  shell   => '/bin/bash',
	  comment => 'Tomcat User',
	}

	class { 'apache': 
	} # use apache module
  	apache::vhost { 'example.com':  # define vhost resource
      		port    => '80',
     		docroot => '/var/www/html'
  	}
	
}
*/

node 'db1.example.com' {
  include common
  include mysql
}

node 'www1.example.com', 'www2.example.com', 'www3.example.com' {
  include common
  include apache, squid
}

node /^www(\d+)\.*/ {
  include common
}

node /^(foo|bar)\.example\.com$/ {
  include common
}

# applies to nodes that aren't explicitly defined
node default {
/*
	file { '/etc/environment':                                        # resource type file and filename
  	ensure  => present,                                               # make sure it exists
	mode    => '644',
	content => 'PATH=$PATH:/opt/puppetlabs/bin',
	}
*/

    package { 'epel-release':
        provider => yum,
        ensure   => present,
    	source   => $epel_url,
    } 

    package { ['bash-completion', 'telnet', 'bind-utils', 'net-tools']:
	provider => $package_manager,
	ensure   => present,
    }

    exec { 'yum update':
	command => 'yum update -y',	
	path    => '/usr/sbin',
	noop    => true,
    }
}
