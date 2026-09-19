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

After that, I can deploy changes with this command (this builds in the
remote):

```sh
export TARGET_HOST="panda@panda"
export TARGET_CONFIG="new_host"
nixos-rebuild \
	--flake ".#$TARGET_CONFIG" \
	--build-host "$TARGET_HOST" --target-host "$TARGET_HOST" \
	--no-reexec --sudo --ask-sudo-password \
	switch
```


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
