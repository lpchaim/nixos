{
  perSystem = {pkgs, ...}: {
    make-shells.rust = {
      additionalArguments.meta.description = "For building Rust projects";
      packages = with pkgs; [
        cargo
        libx11
        openssl
        pkg-config
        rust-analyzer
        rustc
        rustfmt
        rustPackages.clippy
        vscode-extensions.vadimcn.vscode-lldb
      ];
      env.RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
    };
  };
}
