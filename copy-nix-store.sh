#!/usr/bin/env bash

if [ -z $1 ]; then
  echo "Please provide a image digest as the first parameter...";
  exit 1;
fi

set -eu

DOCKERCONTAINER="$1"
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACKUPDIR="$SCRIPTDIR/nix-backup"
HELPERDIR="$SCRIPTDIR/helper"

rm -rf "$BACKUPDIR" || true
mkdir -p "$BACKUPDIR"

docker run --entrypoint=/helper/copy-nix-store-helper.sh \
  -v "$BACKUPDIR":/backup:rw \
  -v "$HELPERDIR":/helper:ro \
  $DOCKERCONTAINER
