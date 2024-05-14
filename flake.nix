{
  description = "Personal NixOS flake";

  inputs = {
    # Nixpkgs
    stable.url = "github:NixOS/nixpkgs/23.11";
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
      inputs.nixpkgs.follows = "stable";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nix-software-center.url = "github:vlinkz/nix-software-center";
    nur.url = "github:nix-community/NUR";
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "unstable";
      inputs.nixpkgs-stable.follows = "stable";
    };
  };

  outputs = { self, disko, flake-utils, home-manager, nixpkgs, nur, snowfall-flake, sops-nix, ... }@inputs:
    let
      myLib = import ./lib { inherit inputs; };
      inherit (myLib) makeHomeConfig makeOsConfig makeOsHomeModule;

      homeModules = {
        "cheina@pc079" = [
          (import ./traits/home-manager/base.nix { stateVersion = "23.05"; username = "cheina"; })
          ./traits/home-manager/cheina.nix
          ./traits/home-manager/non-nixos.nix
        ];
        "lpchaim@laptop" = [
          (import ./traits/home-manager/base.nix { stateVersion = "23.05"; username = "lpchaim"; })
          ./traits/home-manager/gnome.nix
          ./traits/home-manager/gui.nix
          ./traits/home-manager/media.nix
        ];
        lpchaim = [ ];
        lupec = [ ];
      };
    in
    {
      nixosConfigurations =
        let
          makeDefault = { modules, nixpkgs ? inputs.unstable, system ? "x86_64-linux" }: makeOsConfig {
            inherit nixpkgs system;
            modules = modules ++ [
              ./traits/nixos/users.nix
              ./traits/nixos/kernel.nix
              ./traits/nixos/wayland.nix
              ./traits/nixos/pipewire.nix
              home-manager.nixosModules.home-manager
              sops-nix.nixosModules.sops
            ];
          };
          makeHomeModule = { modules, nixpkgs ? inputs.unstable, system ? "x86_64-linux" }: makeOsHomeModule {
            inherit modules nixpkgs system;
          };
        in
        {
          laptop = makeDefault {
            modules = [
              ./hardware/laptop/configuration.nix
              ./traits/nixos/gnome.nix
              ./traits/nixos/laptop.nix
              ./traits/nixos/gaming.nix
              (makeHomeModule { inherit nixpkgs; modules = homeModules."lpchaim@laptop"; })
            ];
          };
        };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        myLib = import ./lib { inherit inputs system; };
        inherit (myLib) makePkgs makeDevShell;
        pkgs = makePkgs { };
      in
      rec {
        homeConfigurations =
          let makeDefault = modules: makeHomeConfig { inherit modules system; nixpkgs = inputs.unstable; };
          in builtins.mapAttrs (_: modules: makeDefault modules) homeModules;
        legacyPackages.homeConfigurations = homeConfigurations;

        lib = myLib;

        devShells = {
          default = makeDevShell {
            packages = with pkgs; [
              age
              pre-commit
              ssh-to-age
              sops
            ];
            shellHook = ''
              pre-commit install
            '';
          };
          cheina = makeDevShell {
            packages = with pkgs; [
              nil
              nodePackages.intelephense
              nodePackages.typescript-language-server
              phpactor
              vscode-langservers-extracted
            ];
            shellHook = ''
              zsh
            '';
          };
        };
      }
    );
}
