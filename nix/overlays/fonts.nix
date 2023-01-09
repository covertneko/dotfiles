final: curr:
let
  patchFont = font: curr.stdenv.mkDerivation {
    name = "${font.name}-nf";
    src = font;
    nativeBuildInputs = [ curr.nerd-font-patcher ];
    buildPhase = ''
      find -name \*.ttf -o -name \*.otf -exec nerd-font-patcher -c {} \;
    '';
    installPhase = "cp -a . $out";
  };
in
{
  mplus-outline-fonts-nf = patchFont curr.mplus-outline-fonts.githubRelease;
}
