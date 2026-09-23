{ modulesPath, lib, pkgs, ... }:

let
  toExtraFiles = dir:
    let
      go = currentDir:
        lib.concatMapAttrs
          (name: type:
            let
              path = "${currentDir}/${name}";
            in
            if type == "directory" then
              lib.mapAttrs'
                (relativePath: value: {
                  name = "${name}/${relativePath}";
                  inherit value;
                })
                (go path)
            else
              { ${name} = path; })
          (builtins.readDir currentDir);
    in
    go (toString dir);
in
{
  imports = [
    ../common/nix-experiments.nix
    ../common/neovim.nix
    ../common/openssh.nix
    ../common/mdns.nix
    ../common/binary-cache-pubkeys.nix
    ../common/binary-cache-ncro.nix
    ../common/binary-cache-ncro-lan.nix

    ../common/secrets-setup.nix
    ../common/wireless.nix

    ./users.nix

    ./networking.nix

    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;

      # Need to copy all the firmware blobs
      extraFiles = toExtraFiles pkgs.rpi3-uefi-firmware;
    };

    efi.canTouchEfiVariables = false;
    timeout = 3;
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  programs.neovim.withPython3 = false;
  programs.neovim.withNodeJs = false;
}
