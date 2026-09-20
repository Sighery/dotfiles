{ modulesPath, lib, pkgs, ... }:

{
  imports = [
    ../common/nix-experiments.nix
    ../common/neovim.nix
    ../common/openssh.nix
    ../common/binary-cache-use.nix

    ../common/secrets-setup.nix

    ./users.nix

    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot =
      let
        filesetToExtraFiles = dir:
          builtins.listToAttrs (
            map
              (path: {
                name = lib.removePrefix "${toString dir}/" (toString path);
                value = path;
              })
              (lib.fileset.toList dir)
          );
      in
      {
        enable = true;
        configurationLimit = 10;

        # Need to copy all the firmware blobs
        extraFiles = filesetToExtraFiles ./rpi3_uefi_firmware_v1.52;
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
