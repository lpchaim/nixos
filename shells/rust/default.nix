{ lib
, pkgs
, mkShell
, rustPlatform
, ...
}:

let
  inherit (lib.lpchaim.shell) makeDevShellWithDefaults;
in
makeDevShellWithDefaults {
  inherit pkgs mkShell;
  packages = with pkgs; [
    cargo
    openssl
    pkg-config
    rustc
    rustfmt
    pre-commit
    rustPackages.clippy
    rust-analyzer
    vscode-extensions.vadimcn.vscode-lldb
    xorg.libX11
  ];
  shellHook = ''
    zsh
  '';
  RUST_SRC_PATH = rustPlatform.rustLibSrc;
}
