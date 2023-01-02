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
