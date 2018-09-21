# File managed by Puppet

# HTTP Strict Transport Security (HSTS), force HTTPS for 1 year (86400x365)
add_header Strict-Transport-Security "max-age=31536000; includeSubdomains" always;

# X-Frame protection to prevent clickjacking
add_header X-Frame-Options "SAMEORIGIN";

# XSS-Protection
# XXX: supported by IE 8+ and Webkit browsers only
add_header X-XSS-Protection "1; mode=block";

# Content-Type-Options
add_header X-Content-Type-Options "nosniff";

# Referrer-Policy
add_header Referrer-Policy "strict-origin-when-cross-origin";

# XXX: contrary to apache2, there is no way to
#      have a location match apply to all vhosts
#      so we abuse this generic include file
# prevent access to git storage
location ~ /\.git {
  deny all;
}
