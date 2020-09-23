#!/bin/sh

#docker-volumes /nix/store:/nix/store:ro \
#docker-volumes /nix/var/nix/db:/nix/var/nix/db:ro \
#docker-volumes /nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket:ro \

mkdir -p /backup/nix/var/nix
cp -r /nix/store /backup/nix/store
cp -r /nix/var/nix/db /backup/nix/var/nix/db
