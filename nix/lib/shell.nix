rec {
  makeDevShell = {
    pkgs,
    mkShell,
    packages ? [],
    shellHook ? "",
    ...
  }:
    mkShell {
      inherit packages shellHook;
    };
  makeDevShellWithDefaults = {
    pkgs,
    mkShell,
    packages ? [],
    shellHook ? "",
    ...
  }:
    makeDevShell {
      inherit pkgs mkShell shellHook;
      packages =
        packages
        ++ (with pkgs; [
          age
          alejandra
          nil
          nixpkgs-fmt
          ssh-to-age
          sops
        ]);
    };
}
