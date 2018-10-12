#
# Define: nginx::conf
#
# Define a conf for nginx
#
define nginx::conf (
  Enum['present','absent'] $ensure = 'present',
  Optional[String] $content        = undef,
  Optional[String] $source         = undef,
  Enum[
       'reload','restart',
       'configtest','upgrade'
      ] $service_action            = 'upgrade',
  Optional[String] $owner          = undef,
  Optional[String] $group          = undef,
  Optional[String] $mode           = '0644',
  Boolean $show_diff               = true,
) {
  if $source and $content {
    fail("${module_name} source and content cannot be use at the same time")
  }

  if ! $source and ! $content and ($ensure == 'present') {
    fail("${module_name} source or content must be specified when ensure is present")
  }

  # conf.d
  file { "/etc/nginx/conf.d/${name}":
    ensure    => $ensure,
    content   => $content,
    source    => $source,
    owner     => $owner,
    group     => $group,
    mode      => $mode,
    show_diff => $show_diff,
    notify    => Exec["service nginx ${service_action}"],
    # XXX: "before" is required to prevent a race when a site starts referencing a
    #      new conf file. If the site change is deployed first, it will trigger a
    #      reload which will trip on the missing conf that is about to be deployed
    before    => Exec['service nginx reload'],
  }
}
