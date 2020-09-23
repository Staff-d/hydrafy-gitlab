# [hydrafy-gitlab](https://gitlab.com/griph-dev/hydrafy-gitlab.git)

Allows gitlab-runners to share their `/nix` dir and thus improve compilation
times and leverages the full potential of nix. Only works for docker-runners.

## Use Case

- You don't want to rebuild large dependencies on every run (I am looking at you, CUDA)
- You want to build large, multi staged derivations which depend eachother
- You want to share build results across multiple repositories

## HowTo

The gitlab runners still require the [nixos/nix](https://hub.docker.com/r/nixos/nix/tags)
base image. To share the nix-store you'll have to copy its inital contents to the runner-
host and mount the resulting dir in all docker runners.

To do so, you'll have to follow these steps

1) "Pin" the `nixos/nix`-Image hash: Check the docker repo and copy the sha-hash.
This enables you to reference the image f.e. by
`nixos/nix@sha256:2da921898aa6c89e2e60b1fb72d74525b8464b47412482c7f1cf77b8e707a099`
2) Execute `copy-nix-store.sh` from this repository on your host machine. This script
takes the image name as its first and only parameter (the `nixos/nix@hash` combination)
from which it should copy the nix store. The result is stored in `$CWD/nix-backup`.
3) Locate your gitlab-runner `config.toml` (see (docs)[https://docs.gitlab.com/runner/configuration/advanced-configuration.html]). Locate the correct (runner.docker)[https://docs.gitlab.com/runner/configuration/advanced-configuration.html#volumes-in-the-runnersdocker-section] section
(take care: there may be multiple, one for each of your registered repositories).
4) Update your `volumes` entry to contain two new mount points:
```
volumes=["/path/to/nix-backup/nix/store:/nix/store:rw","/path/to/nix-backup/nix/var/nix/db:/nix/var/nix/db:rw"]
```
5) Restart the runner ( by using `gitlab-runner restart`) or wait for it to pickup the changes.
6) Update the `.gitlab-ci.yml` to only use the image you have pinned above.


## Pitfalls

- The `/nix` dir will be available in every docker-image you use in your pipeline,
even non-nixos images if you use any.

## See also

- Original idea by Arian van Putten over at https://gitlab.com/arianvp/nixos-gitlab-runner
