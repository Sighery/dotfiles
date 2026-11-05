{
  description = "NixOS Configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:Sighery/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ncro = {
      url = "github:manic-systems/ncro/v2.4.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets.url = "github:Sighery/dotfiles-secrets";

    # TODO: Maybe switch to something else?
    # https://github.com/NixOS/nixpkgs/pull/582838
    brave = {
      url = "git+https://codeberg.org/buckley310/brave-browser-nix?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }:
    let
      forAllSystems =
        import ./lib/for-all-systems.nix { inherit (nixpkgs) lib; };

      packagesOverlay = final: prev:
        import ./pkgs final;

      overrides = import ./overrides { inherit (nixpkgs) lib; };

      overlay = nixpkgs.lib.composeManyExtensions [
        packagesOverlay
        overrides
      ];

      packagesFor = system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
        in
        import ./pkgs pkgs;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosModules = import ./modules;
      packages = forAllSystems nixpkgs.lib.systems.flakeExposed packagesFor;
      overlays.default = overlay;

      nixosConfigurations = import ./nixos-systems.nix {
        inherit self forAllSystems;
      };
    };
}
