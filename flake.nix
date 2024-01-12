{
  description = "Personal NixOS flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/23.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    nixneovimplugins = {
      url = "github:jooooscha/nixpkgs-vim-extra-plugins";
      inputs.nixpkgs.follows = "unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "unstable";
    };

    # Misc
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nix-software-center.url = "github:vlinkz/nix-software-center";
    nur.url = "github:nix-community/NUR";
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = { self, disko, flake-utils, home-manager, nixpkgs, nur, snowfall-flake, ... }@inputs:
    let
      myLib = import ./lib { inherit inputs; };
      inherit (myLib) makeHomeConfig makeOsConfig;
    in
    {
      nixosConfigurations =
        let
          makeDefault = modules: makeOsConfig {
            system = "x86_64-linux";
            modules = modules ++ [
              ./traits/nixos/user-lpchaim.nix
              ./traits/nixos/kernel.nix
              ./traits/nixos/wayland.nix
              ./traits/nixos/pipewire.nix
            ];
          };
        in
        {
          laptop = makeDefault [
            ./hardware/laptop/configuration.nix
            ./traits/nixos/gnome.nix
            ./traits/nixos/laptop.nix
            ./traits/nixos/gaming.nix
          ];
        };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        myLib = import ./lib { inherit inputs system; };
        inherit (myLib) makePkgs makeDevShell;
        pkgs = makePkgs { };
      in
      rec {
        homeConfigurations =
          let makeDefault = modules: makeHomeConfig { inherit modules system; };
          in {
            "cheina@pc079" = makeDefault [
              (import ./traits/home-manager/base.nix { stateVersion = "23.05"; username = "cheina"; })
              ./traits/home-manager/cheina.nix
              ./traits/home-manager/non-nixos.nix
            ];
            "lpchaim@laptop" = makeDefault [
              (import ./traits/home-manager/base.nix { stateVersion = "23.05"; username = "lpchaim"; })
              ./traits/home-manager/gnome.nix
              ./traits/home-manager/gui.nix
            ];
            lpchaim = makeDefault [ ];
            lupec = makeDefault [ ];
          };
        legacyPackages.homeConfigurations = homeConfigurations;

        lib = myLib;

        devShells.default = makeDevShell {
          packages = with pkgs; [
            pre-commit
          ];
          shellHook = ''
            pre-commit install
          '';
        };
      }
    );
}
