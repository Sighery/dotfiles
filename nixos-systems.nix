{ nixpkgs, nixpkgs-unstable, sops-nix, home-manager, disko, secrets, sighery-nixpkgs }:

let
  forAllSystems =
    import ./lib/for-all-systems.nix { inherit (nixpkgs) lib; };
  allowUnfreePredicate =
    import ./lib/unfree.nix { inherit (nixpkgs) lib; };

  makeNixosSystem =
    import ./lib/make-nixos-system.nix {
      inherit nixpkgs sops-nix home-manager secrets allowUnfreePredicate;
    };

  unstablePkgs = forAllSystems [ "x86_64-linux" ] (
    system: import nixpkgs-unstable {
      inherit system;
      config.allowUnfreePredicate = allowUnfreePredicate;
    }
  );

  stateVersion = "26.05";
in
{
  loxez = makeNixosSystem {
    inherit stateVersion;
    system = "x86_64-linux";
    timezone = "Europe/Vienna";
    hostname = "loxez";

    extraModules = [
      {
        nixpkgs.overlays = [
          sighery-nixpkgs.overlays.default
          (_: _: {
            davinci-resolve = unstablePkgs.x86_64-linux.davinci-resolve;
          })
        ];
      }
    ];
  };


  tiber = makeNixosSystem {
    inherit stateVersion;
    system = "x86_64-linux";
    timezone = "Europe/Vienna";
    hostname = "tiber";

    extraModules = [
      {
        nixpkgs.overlays = [
          sighery-nixpkgs.overlays.default
        ];
      }
    ];
  };

  sonar = makeNixosSystem {
    inherit stateVersion;
    system = "x86_64-linux";
    timezone = "Europe/Vienna";
    hostname = "sonar";

    extraModules = [
      {
        nixpkgs.overlays = [
          sighery-nixpkgs.overlays.default
        ];
      }
    ];
  };

  wilem = makeNixosSystem {
    inherit stateVersion;
    system = "x86_64-linux";
    timezone = "Europe/Berlin";
    hostname = "wilem";
    desktopSystem = false;

    extraModules = [
      {
        nixpkgs.overlays = [
          sighery-nixpkgs.overlays.default
        ];
      }

      sighery-nixpkgs.nixosModules.goaccess
      sighery-nixpkgs.nixosModules.syncthing-relay
    ];
  };

  panda = makeNixosSystem {
    inherit stateVersion;
    timezone = "Europe/Vienna";
    system = "aarch64-linux";
    hostname = "panda";
    desktopSystem = false;

    extraModules = [
      disko.nixosModules.disko
    ];
  };
}
