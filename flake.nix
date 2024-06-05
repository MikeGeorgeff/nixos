{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs2311.url = "github:nixos/nixpkgs/nixos-23.11";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs2311, home-manager, nixos-hardware, ... } @inputs: {
      nixosConfigurations = {
        gharial = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/gharial/configuration.nix
            nixos-hardware.nixosModules.framework-16-7040-amd
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.admin = import ./users/admin/gharial.nix;
            }
          ];
          specialArgs = { inherit inputs; };
        };

        condor = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/condor/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.admin = import ./users/admin/condor.nix;
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
              home-manager.users.admin = import ./users/admin/saola.nix;
            }
          ];
          specialArgs = { inherit inputs; };
        };

        addax = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/addax/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };

        vaquita = nixpkgs2311.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/vaquita/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };
  };
}
