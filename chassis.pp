$cavalcade_config = sz_load_config()

class { 'cavalcade':
	path   => '/vagrant/extensions/cavalcade',
	wproot => $cavalcade_config[mapped_paths][base]
}
