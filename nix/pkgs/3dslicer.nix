{ stdenv
, lib
, fetchFromGitHub
, cmake
, git
, wrapQtAppsHook
, qtbase
, qtmultimedia
, qtscript
, qtsvg
, qttools
, qtwebengine
, qtx11extras
, qtxmlpatterns
, bzip2
, curl
, dcmtk
, libarchive
, libffi
, libXt
, openssl
, rapidjson
, sqlite
}:
# based on https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=3dslicer
stdenv.mkDerivation rec {
  pname = "3dslicer";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "Slicer";
    repo = "Slicer";
    rev = "v${version}";
    hash = "sha256-iI+TZ+iyHYyIxHQGbSV/srKo8RSrIX5MHse9kos5IF0=";
  };

  # TODO: why is git required for the build?
  nativeBuildInputs = [ cmake wrapQtAppsHook git ];

  buildInputs = [
    bzip2
    curl
    dcmtk
    libarchive
    libffi
    libXt
    openssl
    rapidjson
    sqlite
    # teem
  # ] ++ (with libsForQt5.qt5; [
    qtbase
    qtmultimedia
    qtscript
    qtsvg
    qttools
    qtwebengine
    qtx11extras
    qtxmlpatterns
  ];
  # ]);

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DCMAKE_BUILD_TYPE:STRING=Release"
    "-DCMAKE_INSTALL_PREFIX:STRING=/usr"
    "-DSlicer_BUILD_DOCUMENTATION=OFF"
    "-DSlicer_BUILD_I18N_SUPPORT=ON"
    "-DSlicer_STORE_SETTINGS_IN_APPLICATION_HOME_DIR=OFF"
    "-DSlicer_USE_GIT_PROTOCOL=OFF"
    "-DSlicer_USE_SYSTEM_CTK=OFF"
    "-DSlicer_USE_SYSTEM_CTKAPPLAUNCHER=OFF"
    "-DSlicer_USE_SYSTEM_CTKAppLauncherLib=OFF"
    "-DSlicer_USE_SYSTEM_CTKResEdit=OFF"
    "-DSlicer_USE_SYSTEM_DCMTK=ON"
    "-DSlicer_USE_SYSTEM_ITK=OFF"
    "-DSlicer_USE_SYSTEM_JsonCpp=OFF"
    "-DSlicer_USE_SYSTEM_LZMA=ON"
    "-DSlicer_USE_SYSTEM_LibArchive=ON"
    "-DSlicer_USE_SYSTEM_LibFFI=ON"
    "-DSlicer_USE_SYSTEM_OpenSSL=ON"
    "-DSlicer_USE_SYSTEM_PCRE=OFF"
    "-DSlicer_USE_SYSTEM_ParameterSerializer=OFF"
    "-DSlicer_USE_SYSTEM_QT=ON"
    "-DSlicer_USE_SYSTEM_RapidJSON=ON"
    "-DSlicer_USE_SYSTEM_SimpleITK=OFF"
    "-DSlicer_USE_SYSTEM_SlicerExecutionModel=OFF"
    "-DSlicer_USE_SYSTEM_Swig=OFF"
    "-DSlicer_USE_SYSTEM_VTK=OFF"
    "-DSlicer_USE_SYSTEM_bzip2=ON"
    "-DSlicer_USE_SYSTEM_curl=ON"
    "-DSlicer_USE_SYSTEM_qRestAPI=OFF"
    "-DSlicer_USE_SYSTEM_sqlite=ON"
    "-DSlicer_USE_SYSTEM_tbb=OFF"
    # "-DSlicer_USE_SYSTEM_teem=ON"
    "-DSlicer_USE_SYSTEM_zlib=ON"
    "-DSlicer_USE_SimpleITK=ON"
    "-DSlicer_USE_SimpleITK_SHARED=ON"
  ];

  installPhase = ''
    make -C "$out/build/Slicer-build" package
    # TODO: install
  '';

  meta = with lib; {
    description = "Multi-platform, free open source software for visualization and image computing.";
    homepage = "https://github.com/Slicer/Slicer";
    #license = # https://github.com/Slicer/Slicer/blob/main/License.txt
    # maintainers = [ ];
  };
}
