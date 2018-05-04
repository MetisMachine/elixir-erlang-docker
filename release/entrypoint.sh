#!/bin/sh

if [ "$(ls -A /etc/envconsul)" ]; then
  ARGS=()
  for i in `find /etc/envconsul -name *.hcl -type f`; do
    echo "Loading config: $i"
    DEREF=$(readlink -f $i)
    ARGS+=("-config=$DEREF")
  done
  ARGS+=("$@")
  echo "envconsul configured, using configured credentials"
  exec /usr/local/bin/envconsul "${ARGS[@]}"
else
  echo "envconsul not configured, running without vault credentials"
  exec "$@"
fi

