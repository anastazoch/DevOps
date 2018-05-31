class ntp::params {
  $package = $facts['os']['family'] ? {
    'RedHat' => 'chrony',
    'Debian' => 'chrony',
    default  => 'chrony',
  }

/*
  case $facts['os']['family'] {
    default: {
      $package     = 'chrony'
      $service     = 'chronyd'
      $ntp_servers = [ '0.debian.pool.ntp.org',
                       '1.debian.pool.ntp.org',
                       '2.debian.pool.ntp.org',
                       '3.debian.pool.ntp.org' ]
    }
    'Debian': {
      $package     = 'chrony'
      $service     = 'chronyd'
      $ntp_servers = [ '0.debian.pool.ntp.org',
                       '1.debian.pool.ntp.org',
                       '2.debian.pool.ntp.org',
                       '3.debian.pool.ntp.org' ]
    }
    'RedHat': {
      $package     = 'chrony'
      $service     = 'chronyd'
      $ntp_servers = [ '0.pool.ntp.org',
                       '1.pool.ntp.org',
                       '2.pool.ntp.org',
                       '3.pool.ntp.org' ]
    }
  }
*/
  $ntp_servers = $operatingsystem ? {
    /(?i-mx:ubuntu|debian)/        => [ '0.debian.pool.ntp.org',
					'1.debian.pool.ntp.org',
					'2.debian.pool.ntp.org',
					'3.debian.pool.ntp.org', ],
    /(?i-mx:centos|fedora|redhat)/ => [ '0.centos.pool.ntp.org',
                                        '1.centos.pool.ntp.org',
                                        '2.centos.pool.ntp.org',
                                        '3.centos.pool.ntp.org', ],
  }
}
