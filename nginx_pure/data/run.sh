#!/usr/bin/with-contenv bashio
set -e

DHPARAMS_PATH=/data/dhparams.pem

CLOUDFLARE_CONF=/data/cloudflare.conf

CONFIG_PATH=$(bashio::config 'config')

# Generate dhparams
if ! bashio::fs.file_exists "${DHPARAMS_PATH}"; then
    bashio::log.info  "Generating dhparams (this will take some time)..."
    openssl dhparam -dsaparam -out "$DHPARAMS_PATH" 4096 > /dev/null
fi

# start server
bashio::log.info "Running nginx..."
exec nginx -c "$CONFIG_PATH" < /dev/null
