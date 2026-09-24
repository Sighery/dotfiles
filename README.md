# Dotfiles

## Update packages

Using [nix-update]:

```sh
nix run github:Mic92/nix-update -- --flake spotify-adblock
```

To specify some version

```sh
nix run github:Mic92/nix-update -- --flake vscode-antislop-settings --version=2a8fb23de3c44ecdd78bf5777da5d6db4b9ebe90
```


## Remote install setup

Using [nixos-anywhere] and [disko]. First I generate the new SSH keys ahead of
time:

```sh
./helpers/create_ssh_keys.sh
```

I can derive the age secrets from the SSH ed25519 key (package `ssh-to-age`):

```sh
cat ./temp-nsystem/etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
```

How to set the SSH password for the remote target:

```sh
# Write a temp file and source it
echo 'export SSHPASS="password"' > ssh-temp
source ssh-temp
```

In `flake.nix` have to add a `./hosts/new_host/hardware-configuration.nix`
for the host modules so nixos-anywhere will fill it out.

The nixos-anywhere command:

```sh
export TARGET_HOST="new_host"
export TARGET_IP="root"
nix run github:nix-community/nixos-anywhere -- \
	--generate-hardware-config nixos-generate-config "./hosts/$TARGET_HOST/hardware-configuration.nix" \
	--env-password \
	--extra-files "./temp-nsystem/" \
	--flake ".#$TARGET_HOST" \
	--target-host "root@$TARGET_IP"
```

### Remote deploy

This requires [accepting the relevant public keys](#binary-cache-pubkeysnix).

Without SSH config:

```sh
export NIX_SSHOPTS="-i ~/.ssh/private_ssh_key"
export TARGET_CONFIG="sonar"
export TARGET_USER="sighery"
export TARGET_HOST="192.168.0.111"
nixos-rebuild \
	--flake ".#$TARGET_CONFIG" \
	--sudo --ask-sudo-password \
	--target-host "$TARGET_USER@$TARGET_HOST" \
	switch
```

When SSH host is already configured:

```sh
export TARGET_CONFIG="panda"
export TARGET_HOST="panda"
nixos-rebuild \
	--flake ".#$TARGET_CONFIG" \
	--sudo --ask-sudo-password \
	--target-host "$TARGET_HOST" \
	switch
```

> [!CAUTION]
> If the remote hasn't accepted the public keys yet, it can be bypassed by
> building on the remote, passing `--build-host "$TARGET_HOST"`.


## Binary cache

[This wiki page is good reference][Signing store paths]. To generate a new key
set:

```sh
export KEY_INDEX="1"
export KEY_NAME="$(hostname)-$KEY_INDEX"
nix key generate-secret --key-name "$KEY_NAME" > "$KEY_NAME.privkey"
nix key convert-secret-to-public < "$KEY_NAME.privkey" > "$KEY_NAME.pubkey"
```

Afterwards, put the `privkey` under `binary_cache` in
`secrets/$hostname/main.yaml`.

### Binary cache files

All the binary cache related stuff is under `hosts/common/binary-cache-*.nix`.

#### [binary-cache-sign.nix]

Uses the `binary_cache` secret of the given host. Will sign packages built on
that host. Required on platforms I will remotely deploy from.

#### [binary-cache-pubkeys.nix]

Allows all the public keys of all my hosts that have package signing enabled.
This should be imported on all devices, regardless of whether they sign their
own packages or not. This is what enables remote deploys without adding the
user to `trusted-users`.

#### [binary-cache-serve.nix]

Serving the local `/nix/store/` over HTTP. It will sign packages on the fly,
even if the packages weren't signed when built. Still only relevant for hosts
that sign packages.

#### [binary-cache-ncro.nix]

Enabling [ncro] as an HTTP proxy router over all the relevant caches
(substituters). The included `substituters` implementation from Nixpkgs is
really dumb, it will try all the substituters sequentially, with exponential
backoffs for every offline cache.

For my usecase with local caches from devices that might be offline, it is
completely unusable.

This one adds the NixOS cache and the ncro cache (which will be removed once
ncro gets merged into nixpkgs).

Usable for all hosts since building `ncro` takes forever, so I need to use the
ncro cache.

#### [binary-cache-ncro-lan.nix]

Adding the local caches to ncro. Right now only `loxez` and `tiber` serve
their stores as a cache, and they only serve in my home LAN, so importing this
is only relevant for home LAN devices (like `panda`), but not for external
devices (like `wilem`).


## Private secrets flake

My secrets, managed by sops-nix, as well as sensitive data that is not quite
secrets, is in a separate private repository.

SSH access would be an option, but Github provides no fine-grained permissions
for SSH. Personal Access Tokens (PAT) do allow for this, where you can specify
a repository, as well as specific permissions to it.

So I generate a new PAT for my private repo, with Contents read-only
permission.

To then use this in my systems, I need this env variable:

```sh
export NIX_CONFIG='access-tokens = github.com=pat_here'
```



[nix-update]: https://github.com/Mic92/nix-update
[nixos-anywhere]: https://github.com/nix-community/nixos-anywhere
[disko]: https://github.com/nix-community/disko
[Signing store paths]: https://wiki.nixos.org/wiki/Signing_store_paths
[binary-cache-sign.nix]: hosts/common/binary-cache-sign.nix
[binary-cache-pubkeys.nix]: hosts/common/binary-cache-pubkeys.nix
[binary-cache-serve.nix]: hosts/common/binary-cache-serve.nix
[binary-cache-ncro.nix]: hosts/common/binary-cache-ncro.nix
[binary-cache-ncro-lan.nix]: hosts/common/binary-cache-ncro-lan.nix
[ncro]: https://github.com/manic-systems/ncro
