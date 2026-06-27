{ pkgs, config, lib, inputs, ... }:

{
  imports = [
    ../common/nix-experiments.nix
    ../common/neovim.nix
    ../common/openssh.nix

    ../common/secrets-setup.nix

    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    ./users.nix
    ./nginx.nix
    ./fail2ban.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  networking.hostName = "wilem";
  networking.domain = "";
  networking.firewall.enable = true;

  services.openssh.ports = inputs.dotfiles-secrets.wilem.ssh.ports;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnbrcZkPamaq6zB8lqfkbNno2C2+pAw0h+ZxrXChRiW"
  ];

  programs.neovim.withPython3 = false;
  programs.neovim.withNodeJs = false;

  environment.systemPackages = with pkgs; [
    rrsync
  ];

  system.stateVersion = "26.05";
}
