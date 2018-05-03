#!/bin/sh

if [ "$(ls -A /etc/envconsul)" ]; then
  echo "envconsul configured, using configured credentials"
  exec /usr/local/bin/envconsul -config=/etc/vault-env "$@"
else
  echo "envconsul not configured, running without vault credentials"
  exec "$@"
fi

