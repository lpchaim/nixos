{
  perSystem = {pkgs, ...}: {
    make-shells.rust = {
      additionalArguments.meta.description = "For building Rust projects";
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
      env.RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
    };
  };
}
