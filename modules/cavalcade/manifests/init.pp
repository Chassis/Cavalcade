# Cavalcade is a replacement for WordPress' built-in cron that runs as a daemon on your system
class cavalcade (
  $path = '/vagrant/extensions/cavalcade',
  $wproot = '/vagrant'
) {
  if versioncmp($::operatingsystemmajrelease, '15.04') >= 0 {
    file { '/lib/systemd/system/cavalcade.service':
      ensure  => 'file',
      content => template('cavalcade/systemd.service.erb'),
    }
    File['/lib/systemd/system/cavalcade.service'] -> Service['cavalcade']
  } else {
    file { '/etc/init/cavalcade.conf':
      ensure  => 'file',
      content => template('cavalcade/upstart.conf.erb'),
    }
    File['/etc/init/cavalcade.conf'] -> Service['cavalcade']
  }

  service { 'cavalcade':
    ensure => 'running',
  }
}
