# Define squid::cond.d::permisos.pp
#
# Used to define permisos
#
# type_redirection = '', always_direct, never_direct
# action options = allow, deny
define squid::permisos (
  $type_redirection    = '',
  $action              = '',
  $acl1                = '',
  $acl2                = '',
  $order               = '',
  $template            = 'squid/conf.d/permisos.conf.erb'
) {

  include squid

  $manage_device_file_content = $template ? {
    ''      => undef,
    default => template($template),
  }

  $manage_device_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_storage_service_autorestart = $squid::bool_service_autorestart ? {
    true    => Service[$squid_service],
    default => undef,
  }

  file { "permisos-${name}.conf":
    ensure  => $squid::manage_file,
    path    => "${squid::config_dir}/conf.d/${order}-permisos-${name}.conf",
    mode    => $squid::config_file_mode,
    owner   => $squid::config_file_owner,
    group   => $squid::config_file_group,
    require => Package[$squid_service],
    notify  => $manage_squid_service_autorestart,
    content => $manage_device_file_content,
    source  => $manage_device_file_source,
    replace => $squid::manage_file_replace,
    audit   => $squid::manage_audit,
  }
}

