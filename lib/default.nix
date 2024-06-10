{ inputs
, system ? "x86_64-linux"
, ...
}@args:

let
  nixosModules = with inputs; [
    ../traits/nixos/base.nix
    disko.nixosModules.disko
    home-manager.nixosModules.home-manager
    nur.nixosModules.nur
    sops-nix.nixosModules.sops
    stylix.nixosModules.stylix
  ];
  homeModules = with inputs; [
    ../modules/home-manager
    ../traits/home-manager/base.nix
    nixvim.homeManagerModules.nixvim
    stylix.homeManagerModules.stylix
  ];
  getDevShellPackages = p: with p; [
    nil
    nixpkgs-fmt
    snowfallorg.flake
  ];
  nixpkgsImportArgs = { config.allowUnfree = true; };
  overlays =
    let
      external = with inputs; [
        nixneovimplugins.overlays.default
        snowfall-flake.overlays.default
      ];
    in
    external
    ++ [
      (final: _prev: {
        stable = import inputs.nixpkgs-stable (nixpkgsImportArgs // {
          inherit (final) system;
          overlays = external;
        });
        unstable = import inputs.nixpkgs-unstable (nixpkgsImportArgs // {
          inherit (final) system;
          overlays = external;
        });
      })
    ];
in
rec {
  makePkgs = { nixpkgs ? inputs.nixpkgs, system ? args.system, ... }:
    import nixpkgs (nixpkgsImportArgs // { inherit overlays system; });

  makeNixosConfig = { modules ? [ ], ... }@args:
    let pkgs = makePkgs args;
    in args.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = nixosModules ++ modules;
      specialArgs = { inherit inputs pkgs system; };
    };

  makeNixosHomeModule = { modules ? [ ], username ? "lpchaim", ... }@args:
    let pkgs = makePkgs args;
    in {
      home-manager = {
        backupFileExtension = "bak";
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = {
          imports = homeModules ++ modules;
          config.home.enableNixpkgsReleaseCheck = false;
        };
        extraSpecialArgs = { inherit inputs pkgs system; };
      };
    };

  makeHomeConfig = { modules ? [ ], ... }:
    let pkgs = makePkgs args;
    in inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = homeModules ++ modules;
      extraSpecialArgs = { inherit inputs pkgs system; };
    };

  makeDevShell = { packages ? [ ], shellHook ? "", ... }@args:
    let pkgs = makePkgs args;
    in pkgs.mkShell {
      inherit shellHook;
      packages = (getDevShellPackages pkgs) ++ packages;
    };
}
