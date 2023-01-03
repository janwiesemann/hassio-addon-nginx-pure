# Home Assistant Add-on: NGINX pure

## How to use

This is a fork of the official NGINX proxy plugin. This one is quite stupid. You have to do everything yourself. This means, nginx will run with a config you need to provide.

The following section was already present in the original documentation. This is one thing, you'll have to change:
> 3. And you need to add the `trusted_proxies` section (requests from reverse proxies will be blocked if these options are not set).
> 
>    ```yaml
>    http:
>      use_x_forwarded_for: true
>      trusted_proxies:
>        - 172.30.33.0/24
>    ```

## Example config:
```nginx
daemon off;
error_log stderr;
pid /var/run/nginx.pid;

events {
	worker_connections 1024;
}

http {
    map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
    }

    server_tokens off;

    server_names_hash_bucket_size 64;
	
    # intermediate configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
	
    server {
        server_name _;
        listen 80 default_server;
        access_log /dev/stdout;

        return 301 https://$host$request_uri;
    }

    server {
        server_name _;
        listen 443 ssl http2 default_server;
        access_log /dev/stdout;

        ssl_session_timeout 1d;
        ssl_session_cache shared:MozSSL:10m;
        ssl_session_tickets off;
        ssl_certificate /ssl/fullchain.pem;
        ssl_certificate_key /ssl/privkey.pem;

        # dhparams file
        ssl_dhparam /data/dhparams.pem;

        proxy_buffering off;

        location / {
            proxy_pass http://homeassistant.local.hass.io:8123;
            proxy_set_header Host $host;
            proxy_redirect http:// https://;
            proxy_http_version 1.1;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
        }
    }
}
```