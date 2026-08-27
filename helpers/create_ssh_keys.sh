#!/usr/bin/env bash

# Based on:
# https://nix-community.github.io/nixos-anywhere/howtos/secrets.html#example-decrypting-an-openssh-host-key-with-pass

# Create a temporary directory
temp="./temp-nsystem"
mkdir -p "$temp"

# Create the directory where sshd expects to find the host keys
install -d -m755 "$temp/etc/ssh"

# Create the default keys
yes | ssh-keygen -t rsa -f "$temp/etc/ssh/ssh_host_rsa_key" -C "" -q -N ""
yes | ssh-keygen -t ed25519 -f "$temp/etc/ssh/ssh_host_ed25519_key" -C "" -q -N ""

