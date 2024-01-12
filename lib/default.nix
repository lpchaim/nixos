{ inputs, system ? "x86_64-linux", pkgs ? import inputs.nixpkgs { inherit system; }, ... }@args:

rec {
  makePkgs = { system ? args.system, nixpkgs ? inputs.nixpkgs, overlays ? [ ] }: import nixpkgs {
    inherit overlays system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  makeOsConfig = { system ? inputs.system, nixpkgs ? inputs.nixpkgs, modules ? [ ] }:
    let
      pkgs = makePkgs {
        inherit nixpkgs system;
        overlays = [
          inputs.snowfall-flake.overlays.default
        ];
      };
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = modules ++ [
        ../traits/nixos/base.nix
        inputs.disko.nixosModules.disko
        inputs.nur.nixosModules.nur
      ];
      specialArgs = { inherit inputs pkgs system; };
    };

  makeHomeConfig = { nixpkgs ? inputs.unstable, system ? inputs.system, modules ? [ ] }:
    let
      pkgs = makePkgs {
        inherit nixpkgs system;
        overlays = [
          inputs.nixneovimplugins.overlays.default
        ];
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = modules ++ [
        ../modules/home-manager
        inputs.nixvim.homeManagerModules.nixvim
      ];
      extraSpecialArgs = { inherit inputs pkgs system; };
    };

  makeDevShell = { packages ? [ ], shellHook ? "" }: pkgs.mkShell {
    inherit shellHook;
    packages = with pkgs; [
      nil
      nixd
      nixpkgs-fmt
      rustup
      rnix-lsp
    ] ++ packages;
  };
}
