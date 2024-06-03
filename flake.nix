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
      inputs.nixpkgs.follows = "nixpkgs";
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
      inherit (myLib) makeHomeConfig makeOsConfig makeOsHomeModule;
      osModules =
        let
          getTraits = traits: map (mod: ./traits/nixos/${mod}.nix) traits;
          getTraitsWithDefaults = traits: getTraits ([ "users" "kernel" "wayland" "pipewire" "hyprland" ] ++ traits);
          makeHomeModule = { modules, nixpkgs ? inputs.nixpkgs, system ? defaultSystem }:
            makeOsHomeModule { inherit modules nixpkgs system; };
        in
        {
          "laptop" = (getTraitsWithDefaults [ "laptop" "gnome" "gaming" ]) ++ [
            ./hardware/laptop/configuration.nix
            (makeHomeModule { modules = homeModules."lpchaim@laptop"; })
          ];
        };
      homeModules =
        let
          getTraits = traits: map (mod: ./traits/home-manager/${mod}.nix) traits;
          getBaseModule = { stateVersion, username ? "lpchaim", homeDirectory ? "/home/${username}" }:
            { imports = getTraits [ "base" ]; home = { inherit username stateVersion; homeDirectory = builtins.toPath homeDirectory; }; };
        in
        {
          "lpchaim@laptop" = (getTraits [ "gnome" "hyprland" "gui" "media" ])
            ++ [ (getBaseModule { stateVersion = "23.05"; }) ];
          "cheina@pc079" = (getTraits [ "non-nixos" "cheina" ])
            ++ [ (getBaseModule { stateVersion = "23.05"; username = "cheina"; }) ];
        };
    in
    {
      nixosConfigurations =
        let
          makeDefault = { modules, nixpkgs ? inputs.nixpkgs, system ? defaultSystem }:
            makeOsConfig { inherit modules nixpkgs system; };
        in
        builtins.mapAttrs (_: modules: makeDefault { inherit modules; }) osModules;
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
