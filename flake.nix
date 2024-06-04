{
  description = "Personal NixOS flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixneovimplugins = {
      url = "github:jooooscha/nixpkgs-vim-extra-plugins";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    ags = {
      url = "github:Aylur/ags/05e0f23534fa30c1db2a142664ee8f71e38db260";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dots-hyprland = {
      url = "github:end-4/dots-hyprland";
      flake = false;
    };

    # Misc
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nix-software-center.url = "github:vlinkz/nix-software-center";
    nur.url = "github:nix-community/NUR";
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, flake-utils, ... }@inputs:
    let
      defaultSystem = "x86_64-linux";
      myLib = import ./lib { inherit inputs; system = defaultSystem; };
      inherit (myLib) makeHomeConfig makeNixosConfig makeNixosHomeModule;
      nixosModules =
        let
          getTraitModules = traits: map (mod: ./traits/nixos/${mod}.nix) traits;
          getTraitModulesWithDefaults = traits: getTraitModules ([ "users" "kernel" "wayland" "pipewire" "hyprland" ] ++ traits);
          makeHomeModule = { modules, nixpkgs ? inputs.nixpkgs, system ? defaultSystem }:
            [ (makeNixosHomeModule { inherit modules nixpkgs system; }) ];
        in
        {
          "laptop" = [ ./hardware/laptop/configuration.nix ]
            ++ (makeHomeModule { modules = homeModules."lpchaim@laptop"; })
            ++ (getTraitModulesWithDefaults [ "laptop" "gnome" "gaming" ]);
        };
      homeModules =
        let
          getTraitModules = traits: map (mod: ./traits/home-manager/${mod}.nix) traits;
          makeBaseModule = { stateVersion, username ? "lpchaim", homeDirectory ? "/home/${username}" }:
            [{ home = { inherit homeDirectory stateVersion username; }; }];
        in
        {
          "lpchaim@laptop" = (makeBaseModule { stateVersion = "23.05"; })
            ++ (getTraitModules [ "gnome" "hyprland" "gui" "media" ]);
          "cheina@pc079" = (makeBaseModule { stateVersion = "23.05"; username = "cheina"; })
            ++ (getTraitModules [ "non-nixos" "cheina" ]);
        };
    in
    {
      nixosConfigurations =
        let
          makeDefault = { modules, nixpkgs ? inputs.nixpkgs, system ? defaultSystem }:
            makeNixosConfig { inherit modules nixpkgs system; };
        in
        builtins.mapAttrs (_: modules: makeDefault { inherit modules; }) nixosModules;
      homeConfigurations =
        let
          makeDefault = { modules, nixpkgs ? inputs.nixpkgs, system ? defaultSystem }:
            makeHomeConfig { inherit modules nixpkgs system; };
        in
        builtins.mapAttrs (_: modules: makeDefault { inherit modules; }) homeModules;
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        myLib = import ./lib { inherit inputs system; };
        inherit (myLib) makePkgs makeDevShell;
        pkgs = makePkgs { inherit system; };
      in
      {
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
