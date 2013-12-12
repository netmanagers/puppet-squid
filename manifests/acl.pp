# Define squid::cond.d::acl.pp
#
# Used to define acl
#
# type options = external, src, dst, dstdomain, url_regex, req_mime_type and  urlpath_regex
define squid::acl (
  $type,
  $vaalues,
  $template = 'squid/conf.d/acl.conf.erb'
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

  $manage_squid_service_autorestart = $squid::bool_service_autorestart ? {
    true    => Service[$squid_service],
    default => undef,
  }

  file { "acl-${name}.conf":
    ensure  => $squid::manage_file,
    path    => "${squid::config_dir}/conf.d/acl-${name}.conf",
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

