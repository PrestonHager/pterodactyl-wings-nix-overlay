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
        version = "1.12.3";

        src = pkgs.fetchFromGitHub {
          owner = "pterodactyl";
          repo = "wings";
          rev = "v${version}";
          hash = "sha256-+iEKAliBJlM/Af5uBGzv4B/zkcXSF9sBvSswMwhu5/w=";
        };

        vendorHash = "sha256-BtATik0egFk73SNhawbGnbuzjoZioGFWeA4gZOaofTI=";

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