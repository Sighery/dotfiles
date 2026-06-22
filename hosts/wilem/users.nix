{ pkgs, config, ... }:

{
  users.mutableUsers = true;

  # To hash passwords: mkpasswd -m sha-512
  sops.secrets."users/wilem".neededForUsers = true;

  users.users.wilem = {
    enable = true;
    isNormalUser = true;
    createHome = true;
    hashedPasswordFile = config.sops.secrets."users/wilem".path;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAWoGIqTR7VVVGX7kawtK9cSCwZzj4ifHz2uEb/u1f1u"
    ];
  };

  users.groups.rincon.name = "rincon";

  users.users.rincon = {
    enable = true;
    isSystemUser = true;
    group = "rincon";
    # Seems this is required, nologin will just not work?
    shell = pkgs.bashInteractive;
    openssh.authorizedKeys.keys = [
      ''command="${pkgs.rrsync}/bin/rrsync -wo /var/www/rincon",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJsewicT+AVQjilZvMFkozULz9amL0Ioy97DpmCW1KQF''
    ];
  };
}
