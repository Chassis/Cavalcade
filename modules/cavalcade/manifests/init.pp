# Cavalcade is a replacement for WordPress' built-in cron that runs as a daemon on your system
class cavalcade (
	$config
) {
	# Set up variables for our templates.
	$path = '/vagrant/extensions/cavalcade'
	$wproot = $config[mapped_paths][wp]

	$version = $config[php]

	if $version =~ /^(\d+)\.(\d+)$/ {
		$package_version = "${version}.*"
		$short_ver = $version
	}
	else {
		$package_version = "${version}*"
		$short_ver = regsubst($version, '^(\d+\.\d+)\.\d+$', '\1')
	}

	if versioncmp($version, '5.4') <= 0 {
		$php_package = 'php5'
		$php_dir = 'php5'
	}
	else {
		$php_package = "php${short_ver}"
		$php_dir = "php/${short_ver}"
	}

	if ( ! empty( $::config[disabled_extensions] ) and 'chassis/cavalcade' in $config[disabled_extensions] ) {
		$file = absent
		$link = absent
		$present = absent
	} else {
		$file = file
		$link = link
		$present = present
	}

	if versioncmp($::operatingsystemmajrelease, '15.04') >= 0 {
		file { '/lib/systemd/system/cavalcade.service':
			ensure  => $file,
			content => template('cavalcade/systemd.service.erb'),
		}
		File['/lib/systemd/system/cavalcade.service'] -> Service['cavalcade']
	} else {
		file { '/etc/init/cavalcade.conf':
			ensure  => $file,
			content => template('cavalcade/upstart.conf.erb'),
		}
		File['/etc/init/cavalcade.conf'] -> Service['cavalcade']
	}

	file { "/etc/${php_dir}/mods-available/cavalcade.ini":
		ensure  => $present,
		content => template('cavalcade/cavalcade.ini.erb'),
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		require => Package["${php_package}-fpm"],
		notify  => Service["${php_package}-fpm"],
	}

	file { "/etc/${php_dir}/cli/conf.d/cavalcade.ini":
		ensure  => $link,
		target  => "/etc/${php_dir}/mods-available/cavalcade.ini",
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		require => File["/etc/${php_dir}/mods-available/cavalcade.ini"],
	}

	file { "/etc/${php_dir}/fpm/conf.d/cavalcade.ini":
		ensure  => $link,
		target  => "/etc/${php_dir}/mods-available/cavalcade.ini",
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		require => File["/etc/${php_dir}/mods-available/cavalcade.ini"],
	}

	if ( ! empty( $::config[disabled_extensions] ) and 'chassis/cavalcade' in $config[disabled_extensions] ) {
		service { 'cavalcade':
			ensure    => stopped,
			enable    => false,
			restart   => false,
			hasstatus => false
		}
	} else {
		service { 'cavalcade':
			ensure     => running,
			enable     => true,
			hasrestart => true,
			hasstatus  => true
		}
	}
}
