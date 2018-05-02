#!/bin/sh

if test "$(ls -A /etc/envconsul)"; then
  echo "envconsul not configured, running without vault credentials"
  exec "$@"
else
  echo "envconsul configured, using configured credentials"
  exec /usr/local/bin/envconsul -config=/etc/vault-env "$@"
fi

