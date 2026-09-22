{ self, nixpkgs, nixpkgs-unstable, sops-nix, home-manager, disko, ncro, secrets, forAllSystems, stateVersion }:

let
  allowUnfreePredicate =
    import ./lib/unfree.nix { inherit (nixpkgs) lib; };

  makeNixosSystem =
    import ./lib/make-nixos-system.nix {
      inherit nixpkgs sops-nix home-manager disko ncro secrets
        allowUnfreePredicate;
    };

  unstablePkgs = forAllSystems [ "x86_64-linux" ] (
    system: import nixpkgs-unstable {
      inherit system;
      config.allowUnfreePredicate = allowUnfreePredicate;
    }
  );
in
{
  loxez = makeNixosSystem {
    inherit stateVersion;
    system = "x86_64-linux";
    timezone = "Europe/Vienna";
    hostname = "loxez";
    ncroEnabled = true;

    extraModules = [
      {
        nixpkgs.overlays = [
          self.outputs.overlays.default
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
    ncroEnabled = true;

    extraModules = [
      {
        nixpkgs.overlays = [
          self.outputs.overlays.default
        ];
      }
    ];
  };

  sonar = makeNixosSystem {
    inherit stateVersion;
    system = "x86_64-linux";
    timezone = "Europe/Vienna";
    hostname = "sonar";
    ncroEnabled = true;

    extraModules = [
      {
        nixpkgs.overlays = [
          self.outputs.overlays.default
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
          self.outputs.overlays.default
        ];
      }

      self.outputs.nixosModules.goaccess
      self.outputs.nixosModules.syncthing-relay
    ];
  };

  panda = makeNixosSystem {
    inherit stateVersion;
    timezone = "Europe/Vienna";
    system = "aarch64-linux";
    hostname = "panda";
    desktopSystem = false;
    diskoEnabled = true;
    ncroEnabled = true;
  };
}
