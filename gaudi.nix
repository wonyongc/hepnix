let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "gaudi";
    version = "v35r1";

    src = pkgs.fetchgit {
      url = "https://gitlab.cern.ch/wochung/Gaudi";
      rev = "973e789b1b38371ceefe8e6537de350de5df45ee";
      sha256 = "sha256-i/Rr/EN38Ihu3rPHl3lX6FrvjJFexGlsXaXSeZkSnag=";
    };

    buildInputs = hep.core pkgs ++ (with pkgs; [ podio edm4hep VecCore VecGeom vdt SIO LCIO mygeant4 dd4hep evtgen hepPDT ]);
    nativeBuildInputs = hep.wrappers pkgs;

    cmakeFlags = [
        "-DCMAKE_CXX_STANDARD=17"
        "-DCMAKE_BUILD_TYPE=Release"

#        "-DCPPGSL_INCLUDE_DIR=${pkgs.gsl}/include"
        "-DAIDA_INCLUDE_DIRS=${pkgs.AIDA}/src/cpp"
        "-DBUILD_TESTING=OFF"
        "-DGAUDI_USE_GPERFTOOLS=OFF"
#        "-DGAUDI_GENCONF_NO_FAIL=ON"
    ];

    prePhases = [ "sourcePhase" ];

    sourcePhase = ''
    source ${pkgs.mygeant4}/bin/geant4.sh
    source ${pkgs.dd4hep}/bin/thisdd4hep.sh
    '';
}