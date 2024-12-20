{mkPkgs, ...}: {
  perSystem = {
    config,
    inputs',
    lib,
    system,
    ...
  } @ args: let
    inherit (import ./lib.nix (args // {inherit pkgs;})) mkShell;
    pkgs = mkPkgs system;
  in {
    devShells = rec {
      default = deploy;
      deploy = mkShell {
        nativeBuildInputs = with pkgs; [
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
          export NH_FLAKE="$HOME/.config/nixos"
        '';
      };
      rust = mkShell {
        nativeBuildInputs = with pkgs; [
          cargo
          openssl
          pkg-config
          rustc
          rustfmt
          rustPackages.clippy
          rust-analyzer
          vscode-extensions.vadimcn.vscode-lldb
          xorg.libX11
        ];
        RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
      };
    };
  };
}
