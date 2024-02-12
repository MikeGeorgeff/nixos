{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux.pkgs;

    phpExt = ({ enabled, all }: enabled ++ [ all.redis ]);

    php81 = (pkgs.php81.withExtensions phpExt);
    php82 = (pkgs.php82.withExtensions phpExt);
    php83 = (pkgs.php83.withExtensions phpExt);
  in
  {
    devShells.x86_64-linux.php81 = pkgs.mkShell {
      name = "PHP 8.1 Environment";
      buildInputs = [
        php81
        php81.packages.composer
      ];
    };

    devShells.x86_64-linux.php82 = pkgs.mkShell {
      name = "PHP 8.2 Environment";
      buildInputs = [
        php82
        php82.packages.composer
      ];
    };

    devShells.x86_64-linux.php83 = pkgs.mkShell {
      name = "PHP 8.3 Environment";
      buildInputs = [
        php83
        php83.packages.composer
      ];
    };

    devShells.x86_64-linux.docker = pkgs.mkShell {
      name = "Docker Environment";
      buildInputs = with pkgs; [
        docker
        docker-compose
      ];
    };
  };
}
