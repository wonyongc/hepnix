let
  pythonPackages = pkgs: with pkgs; [
#    pandas
    requests
    numpy
    matplotlib
#    jupyter
#    ipython
#    h5py
#    pymongo
    pygments
#    pyqt5
    debugpy
    jinja2
    pyyaml
    six
  ];
in
{
  core = pkgs: with pkgs; [
    (boost175.override { enablePython = true; enableNumpy = true; python = (python310Full.withPackages pythonPackages);})
    cmake
    coin3d
    curl
    doxygen
    fmt
    fftw
    freetype
    gdb
    gsl
    hdf5
    hwloc
    libsForQt5.soqt
    libGLU
    libGL
    libunwind
    libuuid
    libxml2
    nlohmann_json
    microsoft_gsl
    motif
    openssl
    tbb
#    (tbb.overrideAttrs (oldAttrs: rec {
#            version = "2020.2";
#
#            installPhase = oldAttrs.installPhase + ''
#            ${pkgs.cmake}/bin/cmake \
#                -DTBB_ROOT="$out" \
#                -DTBB_OS=Linux \
#                -DSAVE_TO="$out"/lib/cmake/ \
#                -P cmake/tbb_config_generator.cmake
#
#            ${pkgs.cmake}/bin/cmake \
#                -DINSTALL_DIR="$out"/lib/cmake/TBB \
#                -DSYSTEM_NAME=Linux \
#                -DLIB_PATH="$out"/lib \
#                -DINC_PATH="$out"/include \
#                -DTBB_VERSION_FILE="$out"/include/tbb/tbb_stddef.h \
#                -P cmake/tbb_config_installer.cmake
#
#
#            '';
#    }))
    pkg-config
    qt5Full
    sqlite
    xercesc
    vtk
    xz
    xorg.libXext
    xorg.libXmu
    xorg.libX11
    zlib

    catch2_3
    cppunit
    gperftools
    jemalloc
    log4cxx
    range-v3

    clhep
    # (hepmc3.overrideAttrs (oldAttrs: rec { buildInputs = oldAttrs.buildInputs ++ [ nlohmann_json ];}))
    fastjet
    lhapdf
    pythia
    root
    vc

    (python310Full.withPackages pythonPackages)
  ];

  wrappers = pkgs: with pkgs; [
    qt5.wrapQtAppsHook
  ];

  overlays = [
    (final: prev: {
      AIDA = prev.callPackage ./AIDA.nix {};
      SIO = prev.callPackage ./SIO.nix {};
      VecCore = prev.callPackage ./VecCore.nix {};
      VecGeom = prev.callPackage ./VecGeom.nix {};
      vdt = prev.callPackage ./vdt.nix {};
      podio = prev.callPackage ./podio.nix {};
      edm4hep = prev.callPackage ./edm4hep.nix {};
      LCIO = prev.callPackage ./LCIO.nix {};
      mygeant4 = prev.callPackage ./geant4.nix {};
      dd4hep = prev.callPackage ./dd4hep.nix {};
      evtgen = prev.callPackage ./evtgen.nix {};
      hepmc3 = prev.callPackage ./hepmc3.nix {};
      hepPDT = prev.callPackage ./hepPDT.nix {};
      gaudi = prev.callPackage ./gaudi.nix {};
      k4FWCore = prev.callPackage ./k4FWCore.nix {};
      k4SimGeant4 = prev.callPackage ./k4SimGeant4.nix {};
      k4Gen = prev.callPackage ./k4Gen.nix {};
      SimSiPM = prev.callPackage ./SimSiPM.nix {};
    })
  ];


}