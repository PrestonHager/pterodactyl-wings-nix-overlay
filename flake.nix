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
    in
    rec {
      overlays = {
        default = (final: prev: {
          wings = packages.wings;
        });
      };
      packages.wings = pkgs.buildGoModule rec {
        pname = "wings";
        version = "1.13.4";

        src = pkgs.fetchFromGitHub {
          owner = "pterodactyl";
          repo = "wings";
          rev = "v${version}";
          hash = "sha256-McD+dQChR3nAaZp1vsyykAqNvrV+CAmZgmjaOR6D5+c=";
        };

        vendorHash = "sha256-98hvLcpcsZqC0DQ8JQ+xQ/OmvQ2fvO7neSBf3NHLlZw=";

        ldflags = [
          "-s"
          "-w"
          "-X github.com/pterodactyl/wings/system.Version=${version}"
        ];

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