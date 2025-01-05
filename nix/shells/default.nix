{inputs, ...} @ args: let
  inherit (inputs) self;
  inherit ((import ../lib args).config) flake repo;
in {
  perSystem = {
    config,
    inputs',
    lib,
    system,
    ...
  } @ args: let
    inherit (import ./lib.nix (args // {inherit pkgs;})) mkShell;
    pkgs = self.pkgs.${system};
    basePackages = with pkgs; [
      bat
      fish
      git
      helix
    ];
  in {
    devShells = {
      default = mkShell {
        meta.description = "Minimal shell with cli essentials";
        packages = basePackages;
      };
      deploy = mkShell {
        meta.description = "Extra deployment utilities built-in";
        packages =
          basePackages
          ++ (with pkgs; [
            disko
            home-manager
            nh
            nixos-generators
            nixos-rebuild
            (writeShellScriptBin "flake-init" ''
              if [ ! -d "${flake.path}" ]; then
                mkdir -p "${flake.path}"
                git clone --branch develop '${repo.main}' "${flake.path}"
                echo "Repo checked out at ${flake.path}"
              else
                echo 'Repo exists, nothing to do'
              fi
            '')
          ]);
        shellHook = ''
          export EDITOR=hx
          export NH_FLAKE="${flake.path}"
        '';
      };
      rust = mkShell {
        meta.description = "For building Rust projects";
        packages = with pkgs; [
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
