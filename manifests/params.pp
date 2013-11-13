# Class: squid::params
#
# This class defines default parameters used by the main module class squid
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to squid class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class squid::params {

  ### Application related parameters

  $package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'squid3',
    default => 'squid',
  }

  $service = $::operatingsystem ? {
    default => 'squid',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'squid',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'squid',
  }

  $config_dir = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/squid3',
    default => '/etc/squid',
  }

  $config_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/squid/squid.conf',
    default => '/etc/squid/squid.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/squid',
    default                   => '/etc/sysconfig/squid',
  }

  $pid_file = $::operatingsystem ? {
    default => '/var/run/squid.pid',
  }

  $data_dir = $::operatingsystem ? {
    default => '/etc/squid',
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log/squid',
  }

  $log_file = $::operatingsystem ? {
    default => '/var/log/squid/squid.log',
  }

  $port = '42'
  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $firewall = false
  $firewall_tool = ''
  $firewall_src = '0.0.0.0/0'
  $firewall_dst = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false
  $noops = false

  $squid_template = ''

  ## squid.conf parameters
  $visible_hostname = ''
  $squid_ip = '127.0.0.1'
  $squid_port = '3128'
  $cache_peer = ''
  $sibling = ''
  $sibling_name = ''
  $icp_port = ''
  $cache_mem = ''
  $cache_swap_low = ''
  $cache_swap_high = ''
  $maximum_object_size = ''
  $maximum_object_size_in_memory = ''
  $cache_replacement_policy = ''
  $error_directory = ''
  $half_closed_clients = ''
  $shutdown_lifetime = ''
  $buffered_logs = ''
  $pipeline_prefetch = ''
  $client_persistent_connections = ''
  $dead_peer_timeout = ''
  $quick_abort_min = ''
  $quick_abort_max = ''
  $quick_abort_pct = ''
  $via = ''
  $forwarded_for = ''
  $hierarchy_stoplist = ''
  $cache_dir = ''
  $cache_access_log = ''
  $cache_store_log = ''
  $ftp_passive = ''
  $snmp_port = ''
  $coredump_dir = ''
}
