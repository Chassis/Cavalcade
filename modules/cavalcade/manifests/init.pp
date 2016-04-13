class cavalcade (
	$path = "/vagrant/extensions/cavalcade",
	$wproot = "/vagrant"
) {
	file { "/etc/init/cavalcade.conf":
		ensure => "file",
		content => template("cavalcade/upstart.conf.erb"),
	}

	service { "cavalcade":
		ensure => "running",
		require => [ File[ "/etc/init/cavalcade.conf" ] ],
	}
}
