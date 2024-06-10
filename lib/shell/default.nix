{
  shell = rec {
    makeDevShell = { pkgs, packages ? [ ], shellHook ? "", mkShell ? pkgs.mkShell, ... }@args:
      mkShell {
        inherit packages shellHook;
      };
    makeDevShellWithDefaultPackages = { pkgs, packages ? [ ], shellHook ? "", mkShell ? pkgs.mkShell, ... }@args:
      makeDevShell {
        inherit pkgs shellHook mkShell;
        packages = packages ++ (with pkgs; [
          nixd
          nixpkgs-fmt
          snowfallorg.flake
        ]);
      };
  };
}
