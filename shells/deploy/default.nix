{
  lib,
  pkgs,
  mkShell,
  ...
}: let
  inherit (lib.lpchaim.shell) makeDevShellWithDefaults;
in
  makeDevShellWithDefaults {
    inherit pkgs mkShell;
    packages = with pkgs; [
      bat
      disko
      git
      fish
      helix
      home-manager
      nixos-rebuild
    ];
    shellHook = ''
      export NIX_CONFIG="${builtins.readFile pkgs.nix-conf}"
      export EDITOR=hx
      export FLAKE="$HOME/.config/nixos"

      if [ ! -d "$FLAKE" ]; then
        git clone "https://github.com/lpchaim/nixos" "$FLAKE"
      fi
    '';
  }
