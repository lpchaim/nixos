{ lib
, pkgs
, mkShell
, ...
}:

let
  inherit (lib.lpchaim.shared.nix) settings;
  inherit (lib.lpchaim.shell) makeDevShellWithDefaults;
  concat = lib.concatStringsSep " ";
in
makeDevShellWithDefaults {
  inherit pkgs mkShell;
  packages = with pkgs; [
    nixos-rebuild
    zsh
  ];
  shellHook = ''
    zsh
  '';
  NIX_CONFIG = ''
    extra-substituters = ${concat settings.extra-substituters}
    extra-trusted-public-keys = ${concat settings.extra-trusted-public-keys}
  '';
}
