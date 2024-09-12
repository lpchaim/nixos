{
  lib,
  pkgs,
  mkShell,
  writeShellScriptBin,
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
      (writeShellScriptBin "flake-init" ''
        if [ ! -d "$FLAKE" ]; then
          mkdir -p "$FLAKE"
          git clone --branch develop 'https://github.com/lpchaim/nixos' "$FLAKE"
          echo "Repo checked out at $FLAKE"
        else
          echo 'Repo exists, nothing to do'
        fi
      '')
    ];
    shellHook = ''
      export NIX_CONFIG="${builtins.readFile pkgs.nix-conf}"
      export EDITOR=hx
      export FLAKE="$HOME/.config/nixos"
    '';
  }
