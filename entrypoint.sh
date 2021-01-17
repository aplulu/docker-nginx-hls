#!/bin/sh

sed -i "s/{ALLOW_PUBLISH}/$ALLOW_PUBLISH/g" /etc/nginx/nginx.conf
sed -i "s/{HLS_PLAYLIST_LENGTH}/$HLS_PLAYLIST_LENGTH/g" /etc/nginx/nginx.conf
sed -i "s/{HLS_FRAGMENT}/$HLS_FRAGMENT/g" /etc/nginx/nginx.conf

/usr/local/sbin/nginx -g "daemon off;"
