#!/bin/ash

sudo certbot certonly --manual --preferred-challenges=dns --email shadddesous@gmail.com --server https://acme-v02.api.letsencrypt.org/directory --agree-tos --manual-public-ip-logging-ok -d "*.sdesous.fr" -d "sdesous.fr" 
