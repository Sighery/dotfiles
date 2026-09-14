{
  description = "NixOS Configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:Sighery/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sighery-nixpkgs = {
      url = "github:Sighery/sighery-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets.url = "github:Sighery/dotfiles-secrets";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , disko
    , sops-nix
    , home-manager
    , sighery-nixpkgs
    , secrets
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      unstablePkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      stateVersion = "26.05";
      timezone = "Europe/Vienna";
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations.loxez = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          {
            nixpkgs.overlays = [
              sighery-nixpkgs.overlays.default
              (_: _: {
                davinci-resolve = unstablePkgs.davinci-resolve;
              })
            ];
          }

          {
            system.stateVersion = stateVersion;
            networking.hostName = "loxez";
            time.timeZone = timezone;
          }
          ./hosts/loxez/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              sops-nix.homeManagerModules.sops
            ];
            home-manager.extraSpecialArgs = { inherit (inputs) secrets; };

            home-manager.users.sighery = ./home/sighery-loxez/main.nix;
          }

          sops-nix.nixosModules.sops
        ];

        specialArgs = { inherit (inputs) secrets; };
      };

      nixosConfigurations.tiber = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          {
            nixpkgs.overlays = [
              sighery-nixpkgs.overlays.default
            ];
          }

          {
            system.stateVersion = stateVersion;
            networking.hostName = "tiber";
            time.timeZone = timezone;
          }
          ./hosts/tiber/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              sops-nix.homeManagerModules.sops
            ];
            home-manager.extraSpecialArgs = { inherit (inputs) secrets; };

            home-manager.users.sighery = ./home/sighery-tiber/main.nix;
          }

          sops-nix.nixosModules.sops
        ];

        specialArgs = { inherit (inputs) secrets; };
      };

      nixosConfigurations.sonar = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          {
            nixpkgs.overlays = [
              sighery-nixpkgs.overlays.default
            ];
          }

          {
            system.stateVersion = stateVersion;
            networking.hostName = "sonar";
            time.timeZone = timezone;
          }
          ./hosts/sonar/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              sops-nix.homeManagerModules.sops
            ];
            home-manager.extraSpecialArgs = { inherit (inputs) secrets; };

            home-manager.users.sighery = ./home/sighery-sonar/main.nix;
          }

          sops-nix.nixosModules.sops
        ];

        specialArgs = { inherit (inputs) secrets; };
      };

      nixosConfigurations.wilem = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          {
            nixpkgs.overlays = [
              sighery-nixpkgs.overlays.default
            ];
          }

          {
            system.stateVersion = stateVersion;
            networking.hostName = "wilem";
            time.timeZone = "Europe/Berlin";
          }
          ./hosts/wilem/configuration.nix
          sighery-nixpkgs.nixosModules.goaccess
          sighery-nixpkgs.nixosModules.syncthing-relay

          sops-nix.nixosModules.sops
        ];

        specialArgs = { inherit (inputs) secrets; };
      };

      nixosConfigurations.panda = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        modules = [
          disko.nixosModules.disko

          {
            system.stateVersion = stateVersion;
            networking.hostName = "panda";
            time.timeZone = timezone;
          }
          ./hosts/panda/configuration.nix

          sops-nix.nixosModules.sops
        ];

        specialArgs = { inherit (inputs) secrets; };
      };
    };
}
