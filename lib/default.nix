{ inputs, system ? "x86_64-linux", pkgs ? import inputs.stable { inherit system; }, ... }@args:

let
  systemOverlays = [
    inputs.snowfall-flake.overlays.default
  ];
  homeOverlays = [
    inputs.nixneovimplugins.overlays.default
  ];
in
rec {
  makePkgs = { system ? args.system, nixpkgs ? inputs.stable, overlays ? [ ] }: import nixpkgs {
    inherit overlays system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  makeOsConfig = { nixpkgs, system ? inputs.system, modules ? [ ] }:
    let
      overlays = systemOverlays ++ homeOverlays;
      pkgs = makePkgs {
        inherit nixpkgs overlays system;
      };
      unstable = makePkgs {
        inherit overlays system;
        nixpkgs = inputs.unstable;
      };
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = modules ++ [
        ../traits/nixos/base.nix
        inputs.disko.nixosModules.disko
        inputs.nur.nixosModules.nur
      ];
      specialArgs = { inherit inputs pkgs system unstable; };
    };

  defaultHomeModules = [
    ../modules/home-manager
    inputs.nixvim.homeManagerModules.nixvim
  ];

  makeOsHomeModule = { system, nixpkgs, modules ? [ ], username ? "lpchaim" }:
    let
      pkgs = makePkgs {
        inherit nixpkgs system;
        overlays = homeOverlays;
      };
    in
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = {
          imports = defaultHomeModules ++ modules;
          config = {
            home.enableNixpkgsReleaseCheck = false;
          };
        };
        extraSpecialArgs = { inherit inputs pkgs system; };
      };
    };

  makeHomeConfig = { nixpkgs, system ? inputs.system, modules ? [ ] }:
    let
      pkgs = makePkgs {
        inherit nixpkgs system;
        overlays = homeOverlays;
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = defaultHomeModules ++ modules;
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
