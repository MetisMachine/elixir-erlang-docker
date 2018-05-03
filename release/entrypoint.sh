#!/bin/sh

if [ "$(ls -A /etc/envconsul)" ]; then
  CMD="/usr/local/bin/envconsul"
  for i in `find /etc/envconsul -name *.hcl -type f`; do
    echo "Loading config: $i"
    DEREF=$(readlink -f $i)
    CMD="$CMD -config=$DEREF"
  done
  echo "envconsul configured, using configured credentials"
  exec "$CMD $@"
else
  echo "envconsul not configured, running without vault credentials"
  exec "$@"
fi

