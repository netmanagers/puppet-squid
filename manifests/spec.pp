# Class: squid3::spec
#
# This class is used only for rpsec-puppet tests
# Can be taken as an example on how to do custom classes but should not
# be modified.
#
# == Usage
#
# This class is not intended to be used directly.
# Use it as reference
#
class squid3::spec inherits squid3 {

  # This just a test to override the arguments of an existing resource
  # Note that you can achieve this same result with just:
  # class { "squid3": template => "squid3/spec.erb" }

  File['squid3.conf'] {
    content => template('squid3/spec.erb'),
  }

}
