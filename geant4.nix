let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "geant4";
    version = "v10.7.1";

    src = pkgs.fetchgit {
      url = "https://github.com/Geant4/geant4";
      rev = "460fe6dfb2fc3b2e509ee3d8ec5aef963a464b05";
      sha256 = "sha256-MlqJOoMSRuYeG+jl8DFgcNnpEyeRgDCK2JlN9pOqBWA=";
    };

    buildInputs = hep.core pkgs ++ [ podio edm4hep VecCore VecGeom vdt SIO LCIO ];
    nativeBuildInputs = hep.wrappers pkgs;

    cmakeFlags = [
        "-DGEANT4_INSTALL_DATA=ON"
        "-DGEANT4_BUILD_TLS_MODEL=global-dynamic"
        "-DGEANT4_USE_GDML=ON"
        "-DGEANT4_USE_INVENTOR=OFF"
        "-DGEANT4_USE_INVENTOR_QT=ON"
        "-DGEANT4_USE_OPENGL_X11=ON"
        "-DGEANT4_USE_PYTHON=ON"
        "-DGEANT4_USE_QT=ON"
        "-DGEANT4_USE_RAYTRACER_X11=OFF"
        "-DGEANT4_USE_SYSTEM_ZLIB=ONF"
        "-DGEANT4_USE_TBB=ON"
        "-DGEANT4_USE_TOOLSSG=OFF"
        "-DGEANT4_USE_XM=ON"
        "-DGEANT4_USE_SYSTEM_CLHEP=ON"
        "-DGEANT4_BUILD_MULTITHREADED=ON"

      ];

}