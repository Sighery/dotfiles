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
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations = import ./nixos-systems.nix {
        inherit nixpkgs nixpkgs-unstable sops-nix home-manager disko secrets sighery-nixpkgs;
      };
    };
}
