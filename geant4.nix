let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "mygeant4";
    version = "v10.7.1";

    src = pkgs.fetchgit {
      url = "https://github.com/wonyongc/geant4";
      rev = "e1fce4d78dfa77c7013118e5dc2664062d7c072d";
      sha256 = "sha256-PsL4W6vmxw+uOlqxWNwwkyLjjIlbgD3njovn3vPlVs4=";
    };

    buildInputs = hep.core pkgs ++ (with pkgs; [ podio edm4hep VecCore VecGeom vdt SIO LCIO ]);
    nativeBuildInputs = hep.wrappers pkgs;

    cmakeFlags = [

        "-DCMAKE_CXX_STANDARD=17"
        "-DCMAKE_BUILD_TYPE=Release"

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
        "-DGEANT4_USE_TBB=OFF"
        "-DGEANT4_USE_TOOLSSG=OFF"
        "-DGEANT4_USE_XM=ON"
        "-DGEANT4_USE_SYSTEM_CLHEP=ON"
        "-DGEANT4_BUILD_MULTITHREADED=ON"

      ];

}