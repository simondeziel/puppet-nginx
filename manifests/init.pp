#
class nginx (
  Enum['core','full','extras','light'] $flavor = 'core',
  Boolean $default_disable                     = true,
) {
  # XXX: workaround https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=788573
  if $::lsbdistrelease == '14.04' {
    file { '/etc/init.d/nginx':
      source => 'puppet:///modules/nginx/nginx.init.14.04',
      mode   => '0755',
      notify => Service['nginx'],
    }
  }

  service { 'nginx':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [
                   Package["nginx-${flavor}"],
                   File['/etc/nginx/conf.d'],
                   File['/etc/nginx/sites-available'],
                  ],
  }

  exec { ['service nginx reload',
          'service nginx restart',
          'service nginx configtest']:
    refreshonly => true,
    require     => Service['nginx'],
  }

  # if there is a config error, upgrade would still return 0 as it would
  # resort to using the old master with the old config. Since we want to
  # catch and report errors no matter what, we check the config first
  exec { 'service nginx upgrade':
    command     => 'service nginx configtest && service nginx upgrade',
    refreshonly => true,
    require     => Service['nginx'],
  }

  file { '/etc/nginx/certs':
    ensure  => directory,
    require => Package["nginx-${flavor}"],
  }

  file { '/etc/nginx/conf.d':
    ensure  => directory,
    require => Package["nginx-${flavor}"],
  }

  file { '/etc/nginx/sites-available':
    ensure  => directory,
    require => Package["nginx-${flavor}"],
  }

  # the default site is rarely needed
  if $disable_default {
    nginx::site { 'default':
      enabled => false,
    }
  }
}
