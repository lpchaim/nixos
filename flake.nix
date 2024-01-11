{
  description = "Personal NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

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
      makePkgs = { system, nixpkgs ? inputs.nixpkgs, overlays ? [ ] }: import nixpkgs {
        inherit overlays system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };

      makeOsConfig = { system ? "x86_64-linux", nixpkgs ? inputs.nixpkgs, modules ? [ ] }:
        let
          pkgs = makePkgs {
            inherit nixpkgs system;
            overlays = [
              snowfall-flake.overlays.default
            ];
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = modules ++ [
            ./traits/nixos/base.nix
            disko.nixosModules.disko
            nur.nixosModules.nur
          ];
          specialArgs = { inherit inputs pkgs system; };
        };

      makeHomeConfig = { nixpkgs ? inputs.unstable, system ? "x86_64-linux", modules ? [ ] }:
        let
          pkgs = makePkgs {
            inherit nixpkgs system;
            overlays = [
              inputs.nixneovimplugins.overlays.default
            ];
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = modules ++ [
            ./modules/home-manager
            inputs.nixvim.homeManagerModules.nixvim
          ];
          extraSpecialArgs = { inherit inputs pkgs system; };
        };
    in
    {
      nixosConfigurations =
        let
          makeDefault = modules: makeOsConfig {
            system = "x86_64-linux";
            modules = modules ++ [
              ./traits/nixos/kernel-zen.nix
              ./traits/nixos/user-lpchaim.nix
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
        pkgs = makePkgs { inherit system; };
        makeHomeConfigFromModules = modules: makeHomeConfig { inherit modules system; };
      in
      rec {
        homeConfigurations = {
          "cheina@pc079" = makeHomeConfigFromModules [
            (import ./traits/home-manager/base.nix { stateVersion = "23.05"; username = "cheina"; })
            ./traits/home-manager/cheina.nix
            ./traits/home-manager/non-nixos.nix
          ];
          "lpchaim@laptop" = makeHomeConfigFromModules [
            (import ./traits/home-manager/base.nix { stateVersion = "23.11"; username = "lpchaim"; })
            ./traits/home-manager/gnome.nix
            ./traits/home-manager/gui.nix
          ];
          lpchaim = makeHomeConfigFromModules [ ];
          lupec = makeHomeConfigFromModules [ ];
        };

        legacyPackages.homeConfigurations = homeConfigurations;

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
