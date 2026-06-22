{
  description = "NixOS Configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sighery-nixpkgs = {
      url = "github:Sighery/sighery-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-secrets.url = "github:Sighery/dotfiles-secrets?shallow=1";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , sops-nix
    , home-manager
    , sighery-nixpkgs
    , dotfiles-secrets
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

          ./hosts/loxez/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              sops-nix.homeManagerModules.sops
            ];
            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.sighery = import ./home-sighery/main.nix;
          }

          sops-nix.nixosModules.sops
        ];

        specialArgs = { inherit inputs; };
      };

      nixosConfigurations.tiber = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          {
            nixpkgs.overlays = [
              sighery-nixpkgs.overlays.default
            ];
          }

          ./hosts/tiber/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              sops-nix.homeManagerModules.sops
            ];
            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.sighery = import ./home-sighery/main.nix;
          }

          sops-nix.nixosModules.sops
        ];

        specialArgs = { inherit inputs; };
      };

      nixosConfigurations.wilem = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          {
            nixpkgs.overlays = [
              sighery-nixpkgs.overlays.default
            ];
          }

          ./hosts/wilem/configuration.nix
          sighery-nixpkgs.nixosModules.goaccess

          sops-nix.nixosModules.sops
        ];

        specialArgs = { inherit inputs; };
      };
    };
}
