{ nixpkgs
, sops-nix
, home-manager
, disko
, ncro
, secrets
, allowUnfreePredicate
}:

{ stateVersion
, hostname
, desktopSystem ? true
, diskoEnabled ? false
, ncroEnabled ? false
, extraModules ? [ ]
, system ? "x86_64-linux"
, timezone ? "Europe/Vienna"
, ...
}:

nixpkgs.lib.nixosSystem {
  inherit system;

  modules = extraModules
    ++ [
    {
      nixpkgs.config.allowUnfreePredicate = allowUnfreePredicate;

      system.stateVersion = stateVersion;
      networking.hostName = hostname;
      time.timeZone = timezone;
    }
    ../hosts/${hostname}/configuration.nix
  ]
    ++ nixpkgs.lib.optionals (desktopSystem) [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.sharedModules = [
        sops-nix.homeManagerModules.sops
      ];
      home-manager.extraSpecialArgs = { inherit secrets; };

      home-manager.users.sighery = ../home/sighery-${hostname}/main.nix;
    }
  ]
    ++ [
    sops-nix.nixosModules.sops
  ]
    ++ nixpkgs.lib.optional diskoEnabled disko.nixosModules.disko
    ++ nixpkgs.lib.optional ncroEnabled ncro.nixosModules.ncro;

  specialArgs = { inherit secrets; };
}
