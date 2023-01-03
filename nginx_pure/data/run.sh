#!/usr/bin/with-contenv bashio
set -e

bashio::log.info "===> Settings Info <==="
bashio::log.info "Recommended settings"
bashio::log.info "    proxy_pass http://homeassistant.local.hass.io:$(bashio::core.port);"

DHPARAMS_PATH=/data/dhparams.pem

CONFIG_PATH=$(bashio::config 'config')

# Generate dhparams
if ! bashio::fs.file_exists "${DHPARAMS_PATH}"; then
    bashio::log.info  "Generating dhparams (this will take some time)..."
    openssl dhparam -dsaparam -out "$DHPARAMS_PATH" 4096 > /dev/null
fi

# start server
bashio::log.info "Running nginx..."
exec nginx -c "$CONFIG_PATH" < /dev/null
