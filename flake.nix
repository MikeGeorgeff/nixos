{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs2305.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs2305, home-manager, ... } @inputs: {
      nixosConfigurations = {
        pangolin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/pangolin/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.mike = import ./users/mike/home.nix;
            }
          ];
          specialArgs = { inherit inputs; };
        };

        saola = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/saola/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.admin = import ./users/admin/home.nix;
            }
          ];
          specialArgs = { inherit inputs; };
        };

        vaquita = nixpkgs2305.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/vaquita/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };
  };
}
