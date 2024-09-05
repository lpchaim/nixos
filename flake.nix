{
  description = "Personal NixOS flake";

  inputs = {
    # Systems
    systems.url = "github:nix-systems/default-linux";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
    flake-utils-plus.inputs.flake-utils.follows = "flake-utils";

    # Nixpkgs
    nixpkgs.follows = "unstable";
    stable.url = "github:NixOS/nixpkgs/24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixneovimplugins = {
      url = "github:jooooscha/nixpkgs-vim-extra-plugins";
      inputs.nixpkgs.follows = "unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "unstable";
      inputs.home-manager.follows = "home-manager";
    };

    # Hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    ags = {
      url = "github:Aylur/ags/05e0f23534fa30c1db2a142664ee8f71e38db260";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-aylur = {
      url = "github:Aylur/dotfiles";
      inputs.ags.follows = "ags";
      inputs.home-manager.follows = "home-manager";
      inputs.hyprland.follows = "hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-aylur-raw = {
      follows = "dotfiles-aylur";
      flake = false;
    };
    matugen = {
      url = "github:InioX/matugen?ref=v2.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-end-4 = {
      url = "github:end-4/dots-hyprland";
      flake = false;
    };

    # Misc
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "unstable";
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    jovian = {
      follows = "chaotic/jovian";
      inputs.nixpkgs.follows = "chaotic/nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "chaotic/nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-software-center.url = "github:vlinkz/nix-software-center";
    nix-std.url = "github:chessai/nix-std";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "unstable";
      inputs.snowfall-lib.follows = "snowfall-lib";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.flake-utils-plus.follows = "flake-utils-plus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "stable";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}: let
    inherit (snowfallLib.snowfall.attrs) merge-deep;
    inherit (snowfallLib.snowfall.internal.user-lib.shared) defaults;
    snowfallLib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;
      snowfall.namespace = defaults.name.user;
    };
    snowfallConfig = {
      channels-config = {
        allowUnfree = true;
      };

      supportedSystems = import inputs.systems;

      overlays = with inputs; [
        chaotic.overlays.default
        jovian.overlays.default
        nh.overlays.default
        nix-gaming.overlays.default
        nix-software-center.overlays.pkgs
        nixneovimplugins.overlays.default
        snowfall-flake.overlays.default
        (next: prev: {
          nix-conf = let
            homeCfg = self.legacyPackages.${prev.system}.homeConfigurations.minimal.config.home;
            nixCfg = homeCfg.file."${homeCfg.homeDirectory}/.config/nix/nix.conf".source;
          in
            nixCfg;
        })
      ];

      systems.modules.nixos = with inputs; [
        chaotic.nixosModules.default
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        jovian.nixosModules.default
        lanzaboote.nixosModules.lanzaboote
        nix-gaming.nixosModules.pipewireLowLatency
        nix-gaming.nixosModules.platformOptimizations
        nixos-generators.nixosModules.all-formats
        nur.nixosModules.nur
        sops-nix.nixosModules.sops
        stylix.nixosModules.stylix
      ];

      homes.modules = with inputs; [
        ags.homeManagerModules.default
        chaotic.homeManagerModules.default
        nix-index-database.hmModules.nix-index
        nixvim.homeManagerModules.nixvim
        sops-nix.homeManagerModules.sops
        stylix.homeManagerModules.stylix
        wayland-pipewire-idle-inhibit.homeModules.default
      ];

      outputs-builder = channels: {
        formatter = channels.nixpkgs.alejandra;
      };

      alias = {
        shells.default = "deploy";
      };
    };
  in
    merge-deep [
      (snowfallLib.mkFlake snowfallConfig)
      (inputs.flake-utils.lib.eachDefaultSystem (system: let
        inherit (snowfallLib.snowfall) home module;
        homeModules = snowfallLib.pipe ./modules/home [
          (src: module.create-modules {inherit src;})
          builtins.attrValues
        ];
      in {
        legacyPackages.homeConfigurations.minimal = let
          homeData = home.create-home {
            inherit system;
            name = "minimal";
            path = ./homes/minimal;
            channelName = "nixpkgs";
            modules = snowfallConfig.homes.modules ++ homeModules;
            specialArgs = rec {
              username = defaults.name.user;
              homeDirectory = "/home/${username}";
              stateVersion = "24.05";
            };
          };
        in
          homeData.builder {
            inherit (homeData) modules specialArgs;
          };
      }))
    ];
}
