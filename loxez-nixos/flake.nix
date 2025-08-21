{
  description = "NixOS Configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 1.8.0 forces the loop k and ligatures
    fantasque-sans-mono-nixos = {
      url = "github:Sighery/fantasque-sans-mono-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Patched Spotify
    patched-spotify = {
      url = "github:NL-TCH/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      fantasque-sans-mono-nixos,
      patched-spotify,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.loxez = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          {
            nixpkgs.overlays = [
              (_: _: {
                fantasque-sans-mono = fantasque-sans-mono-nixos.packages.${system}.default;
                spotify-adblock = import "${patched-spotify.outPath}/pkgs/spotify-adblock" {
                  inherit (pkgs)
                    spotify
                    stdenv
                    rustPlatform
                    fetchFromGitHub
                    xorg
                    zip
                    unzip
                    ;
                };
              })
            ];
          }

          (import ./configuration.nix { inherit inputs; })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.sighery = import ./home.nix;
          }
        ];
      };
    };
}
