{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  xorg,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "smartcat";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "efugier";
    repo = "smartcat";
    rev = "main";
    hash = "sha256-iCtNNKXo0peGGUaQXKaaYaEo7MAL70PX0BAWPERNmlo=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl.dev
    xorg.libX11.dev
  ];

  PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" buildInputs;

  meta = with lib; {
    homepage = "https://github.com/efugier/smartcat";
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "sc";
    maintainers = with maintainers; [lpchaim];
  };
}
