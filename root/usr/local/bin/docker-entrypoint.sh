#!/bin/sh
# /usr/local/bin/docker-entrypoint.sh

set -e

umask 0002

if [ ! $(id -u $PUSER) == $PUID ]; then
	usermod -u $PUID $PUSER
fi

if [ ! $(id -g $PUSER) == $PGID ]; then
	groupmod -g $PGID $PGROUP
fi

chown -R $PUSER:$PGROUP /scripts
chown $PUSER:$PGROUP /config /data/music /log

if [ "$1" = 'crond' ]; then
	chmod 600 /etc/crontabs/$PUSER
	exec "$@"
else
	exec su-exec $PUSER:$PGROUP "$@"
fi
