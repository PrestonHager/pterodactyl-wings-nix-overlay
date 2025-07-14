(final: prev: {
  wings = pkgs.stdenv.mkDerivation {
    pname = "wings";
    version = "latest";

    src = pkgs.fetchurl {
      url = "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64";
      sha256 = "";
    };

    installPhase = ''
      mkdir -p $out/bin
      mv $src $out/bin/wings
      chmod +x $out/bin/wings
    '';

    meta = with lib; {
      description = "Pterodactyl Wings daemon";
      homepage = "https://pterodactyl.io/";
      license = licenses.mit;
      maintainers = with maintainers; [ ];
      platforms = platforms.linux;
    };
  };
})

