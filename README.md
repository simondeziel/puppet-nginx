# Puppet NGINX

Manages NGINX server via Puppet.

## Requirements
* Ubuntu LTS (14.04 or later)

## Usage

To run NGINX serving the example.com site:

```puppet
  include nginx
  nginx::site { 'example.com':
    source => 'puppet:///modules/example/nginx/sites/example.com',
  }
```
