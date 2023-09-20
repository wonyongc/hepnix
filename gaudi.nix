let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "gaudi";
    version = "v35r1";

    src = pkgs.fetchgit {
      url = "https://gitlab.cern.ch/gaudi/Gaudi";
      rev = "4bafffa1b803cecc9b2536bd5b1084431a7776a9";
      sha256 = "sha256-MlqJOoMSRuYeG+jl8DFgcNnpEyeRgDCK2JlN9pOqBWA=";
    };

    buildInputs = hep.core pkgs ++ [ podio edm4hep VecCore VecGeom vdt SIO LCIO geant4 dd4hep evtgen ];
    nativeBuildInputs = hep.wrappers pkgs;

    cmakeFlags = [
#        "-DCPPGSL_INCLUDE_DIR=${pkgs.gsl}/include"
        "-DAIDA_INCLUDE_DIRS=${AIDA}/src/cpp"
        "-DBUILD_TESTING=OFF"
        "-DGAUDI_USE_GPERFTOOLS=OFF"
#        "-DGAUDI_GENCONF_NO_FAIL=ON"
    ];
}