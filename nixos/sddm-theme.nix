{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "sddm-silent-theme";
  
  src = pkgs.fetchFromGitHub {
    owner = "uiriansan";
    repo = "SilentSDDM";
    rev = "main";
    # Il famoso hash finto, confinato in questo file
    sha256 = "0000000000000000000000000000000000000000000000000000"; 
  };
  
  installPhase = ''
    mkdir -p $out/share/sddm/themes/silent
    cp -r * $out/share/sddm/themes/silent/
  '';
}
