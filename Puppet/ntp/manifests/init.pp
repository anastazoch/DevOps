class ntp (
	$autoupdate,
	$package,
	$conf_file,
	$service,
	$time_servers,
) {

	package { $package: 
		ensure => present,
		before => File["/etc/${conf_file}"],	
	 }

	file { 'conf_file':
		path    => "/etc/${conf_file}",
		ensure  => file,
		content => template("ntp/${conf_file}.erb"),
		require => Package["${package}"],
		notify  => Service["${service}"],
	}

	service { 'service':
		name      => "${service}",
		ensure    => running,
		enable    => true,
		subscribe => File["/etc/${conf_file}"],
	}
}
