#
# Define: nginx::site
#
# Define a site for nginx
#
define nginx::site (
  $ensure         = 'present',
  $enabled        = true,
  $content        = undef,
  $source         = undef,
  $service_action = 'reload',
) {
  if ! ($ensure in [ 'present', 'absent']) {
    fail("${module_name} ensure parameter must be absent or present")
  }

  validate_bool($enabled)

  if $source and $content {
    fail("${module_name} source and content cannot be use at the same time")
  }

  if $enabled and ! $source and ! $content and ($ensure == 'present') {
    fail("${module_name} source or content must be specified when ensure is present and a site is enabled")
  }

  # sites-available
  file { "/etc/nginx/sites-available/${name}":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    notify  => Exec["service nginx ${service_action}"],
  }
  # sites-enabled
  if $enabled and ($ensure == 'present') {
    $enabled_ensure = 'symlink'
  } else {
    $enabled_ensure = 'absent'
  }
  file { "/etc/nginx/sites-enabled/${name}":
    ensure => $enabled_ensure,
    target => "/etc/nginx/sites-available/${name}",
    notify => Exec["service nginx ${service_action}"],
  }
}
