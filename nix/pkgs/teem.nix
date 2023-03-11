{ stdenv, lib, fetchsvn, gcc, cmake }:

stdenv.mkDerivation rec {
  pname = "teem";
  version = "1.11.0";
  description = "Group of libraries for processing scientific raster data";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/teem/code/teem/trunk";
    rev = ""
    sha256 = "a01386021dfa802b3e7b4defced2f3c8235860d500c1fa2f347483775d4c8def";
  };

  nativeBuildInputs = [ gcc cmake ];
  # buildInputs = [];

  buildPhase = "";
}
