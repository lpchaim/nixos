{ inputs
, system ? "x86_64-linux"
, pkgs ? import inputs.nixpkgs { inherit system; }
, ...
}@args:

let
  systemOverlays = [
    inputs.snowfall-flake.overlays.default
  ];
  homeOverlays = [
    inputs.nixneovimplugins.overlays.default
  ];
in
rec {
  makePkgs = { system ? args.system, nixpkgs ? inputs.nixpkgs, overlays ? [ ] }: import nixpkgs {
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
      pkgs-stable = makePkgs {
        inherit overlays system;
        nixpkgs = inputs.nixpkgs-stable;
      };
      pkgs-unstable = makePkgs {
        inherit overlays system;
        nixpkgs = inputs.nixpkgs-unstable;
      };
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = modules ++ [
        ../traits/nixos/base.nix
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
        inputs.nur.nixosModules.nur
        inputs.sops-nix.nixosModules.sops
        inputs.stylix.nixosModules.stylix
      ];
      specialArgs = { inherit inputs pkgs system pkgs-stable pkgs-unstable; };
    };

  defaultHomeModules = [
    ../modules/home-manager
    inputs.nixvim.homeManagerModules.nixvim
    inputs.stylix.homeManagerModules.stylix
  ];

  makeOsHomeModule = { system, nixpkgs ? inputs.nixpkgs, modules ? [ ], username ? "lpchaim" }:
    let
      pkgs = makePkgs {
        inherit nixpkgs system;
        overlays = homeOverlays;
      };
    in
    {
      home-manager = {
        backupFileExtension = "bak";
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

  makeHomeConfig = { nixpkgs ? inputs.nixpkgs, system ? inputs.system, modules ? [ ] }:
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
    ] ++ packages;
  };
}
