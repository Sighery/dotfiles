{ self, forAllSystems }:

let
  inherit (self.inputs) nixpkgs nixpkgs-unstable sops-nix home-manager disko
    ncro vsc-go-away-llms secrets nixpkgs-2605-small;

  allowUnfreePredicate =
    import ./lib/unfree.nix { inherit (nixpkgs) lib; };

  makeNixosSystem =
    import ./lib/make-nixos-system.nix {
      inherit nixpkgs sops-nix home-manager disko ncro
        vsc-go-away-llms secrets allowUnfreePredicate;

      selfOverlay = self.outputs.overlays.default;
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
    ncroEnabled = true;

    extraModules = [
      {
        nixpkgs.overlays = [
          (_: _: {
            davinci-resolve = unstablePkgs.x86_64-linux.davinci-resolve;
            davinci-resolve-studio = unstablePkgs.x86_64-linux.davinci-resolve-studio;
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
  };

  sonar = makeNixosSystem {
    inherit stateVersion;
    system = "x86_64-linux";
    timezone = "Europe/Vienna";
    hostname = "sonar";
    ncroEnabled = true;
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
          (_: _: {
            nginx = nixpkgs-2605-small.legacyPackages.x86_64-linux.nginxStable;
            nginxStable = nixpkgs-2605-small.legacyPackages.x86_64-linux.nginxStable;
            nginxMainline = nixpkgs-2605-small.legacyPackages.x86_64-linux.nginxMainline;
          })
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
