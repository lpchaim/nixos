{
  description = "Personal NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, disko, nixpkgs }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        makeOsConfig = modulesOrPaths:
          let
            modules = builtins.map
              (x: if (builtins.isPath x) then (import x) else x)
              modulesOrPaths;
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ./traits/base.nix
              disko.nixosModules.disko
            ] ++ modules;
          };
        commonModulesDailyDriver = [
          ./traits/kernel-zen.nix
          ./traits/user-lpchaim.nix
          ./traits/graphical.nix
          ./traits/wayland.nix
          ./traits/pipewire.nix
        ];
      in
      {
        packages.nixosConfigurations = {
          laptop = makeOsConfig (commonModulesDailyDriver ++ [
            ./hardware/laptop/configuration.nix
            ./traits/gnome.nix
            ./traits/laptop.nix
          ]);
        };
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nil
            nixd
            nixpkgs-fmt
            pre-commit
            rustup
            rnix-lsp
          ];
          shellHook = ''
            pre-commit install
          '';
        };
      }
    );
}
