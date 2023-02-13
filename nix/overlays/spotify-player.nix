final: curr:
with curr; {
  spotify-player = rustPlatform.buildRustPackage rec {
    pname = "spotify-player";
    version = "0.10.0";

    src = fetchCrate {
      inherit pname version;
      sha256 = "sha256-gBzC4HS5pUyFOew1djonhLtMlqCeFDfKsh2u8lw+lns=";
    };

    nativeBuildInputs = [ pkgconfig ];

    buildInputs = [ openssl libpulseaudio ];

    cargoHash = "sha256-B6NLnNiGK6AxzjSPl5mq3qnztO65NPTsApJBjTwA1CQ=";
    cargoDepsName = pname;

    verifyCargoDeps = true;
    buildNoDefaultFeatures = true;
    buildFeatures = [ "image" "pulseaudio-backend" "lyric-finder" ];

    meta = with lib; {
      description = "A command driven spotify player";
      homepage = "https://github.com/aome510/spotify-player";
      license = licenses.mit;
      # maintainers = [ ];
    };
  };
}
