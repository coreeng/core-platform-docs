#!/usr/bin/env sh

params="--bind 0.0.0.0 --port 8080 --baseURL $BASE_URL --logLevel debug --appendPort=false"
if [ "$LIVE_RELOAD" != true ]; then
  params="$params --disableLiveReload"
fi

exec hugo serve $params