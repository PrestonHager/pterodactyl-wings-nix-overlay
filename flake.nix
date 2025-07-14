{
  description = "Pterodactyl Wings package";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlays."${system}".default ];
      };
      architecture = if system == "x86_64-linux" then "amd64" else "arm64";
    in
    rec {
      overlays = {
        default = (final: prev: {
          wings = packages.wings;
        });
      };
      packages.wings = pkgs.buildGoModule rec {
        pname = "wings";
        version = "1.11.13";

        src = pkgs.fetchurl {
          url = "https://github.com/pterodactyl/wings/archive/refs/tags/v${version}.tar.gz";
          sha256 = "sha256-0nxOSSpRJiCPaeA25GT2X9k94OPJECO5TnQeQn0h1Zw=";
        };

        vendorHash = "sha256-eWfQE9cQ7zIkITWwnVu9Sf9vVFjkQih/ZW77d6p/Iw0=";

        doCheck = false;

        meta = with pkgs.lib; {
          description = "Pterodactyl Wings daemon";
          homepage = "https://pterodactyl.io/";
          license = licenses.mit;
          maintainers = with maintainers; [ ];
          platforms = platforms.linux;
        };
      };
      packages.default = pkgs.wings;
    });
}

