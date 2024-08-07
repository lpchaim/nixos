{
  shell = rec {
    makeDevShell = { pkgs, mkShell, packages ? [ ], shellHook ? "", ... }:
      mkShell {
        inherit packages shellHook;
      };
    makeDevShellWithDefaults = { pkgs, mkShell, packages ? [ ], shellHook ? "", ... }:
      makeDevShell {
        inherit pkgs mkShell;
        packages = packages ++ (with pkgs; [
          age
          nil
          nixd
          nixos-generators
          nixpkgs-fmt
          pre-commit
          ssh-to-age
          snowfallorg.flake
          sops
        ]);
        shellHook = shellHook + ''
          pre-commit install
        '';
      };
  };
}
