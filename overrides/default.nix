{ lib }:

lib.composeManyExtensions [
  (import ./fantasque-sans-mono.nix)
  (import ./spotify.nix)
]
