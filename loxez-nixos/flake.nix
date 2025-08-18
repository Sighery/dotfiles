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
  };

  outputs = { self, nixpkgs, home-manager, fantasque-sans-mono-nixos, ... }@inputs: {
    nixosConfigurations.loxez = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        {
	  nixpkgs.overlays = [
	    (_: _: { fantasque-sans-mono = fantasque-sans-mono-nixos.packages.${system}.default; })
	  ];
	}

        ./configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.sighery = import ./home.nix;
        }
      ];
    };
  };
}
