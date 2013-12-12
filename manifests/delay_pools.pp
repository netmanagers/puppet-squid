# Define squid::cond.d::delay_pools.pp
#
# Used to define delay_pools
#
define squid::delay_pools (
  $size            = '',
  $acl             = '',
  $template        = 'squid/conf.d/delay_pools.conf.erb'
) {

  include squid

  $manage_delay_pools_file_content = $template ? {
    ''      => undef,
    default => template($template),
  }

  $manage_delay_pools_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_squid_service_autorestart = $squid::bool_service_autorestart ? {
    true    => Service[$squid_service],
    default => undef,
  }

  file { "device-${name}.conf":
    ensure  => $squid::manage_file,
    path    => "${squid::configs_dir}/delay_pool-${name}.conf",
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

