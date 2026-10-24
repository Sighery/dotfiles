{ lib }:

pkg: builtins.elem (lib.getName pkg) [
  "spotify"
  "spotify-unwrapped"
  "steam-unwrapped"
  "discord"
  "plexmediaserver"
  "davinci-resolve"
  "davinci-resolve-studio"
  "rar"
  "unrar"

  "nvidia-x11"
  "nvidia-settings"
  "nvidia-kernel-modules"

  "vscode-extension-MS-python-vscode-pylance"
  "vscode-extension-ms-vsliveshare-vsliveshare"
]
