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
    nixpkgs-cuda.follows = "nixpkgs";
    nixpkgs-steamdeck.follows = "nixpkgs";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixneovimplugins = {
      url = "github:jooooscha/nixpkgs-vim-extra-plugins";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astal = {
      url = "github:Aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-aylur = {
      url = "github:Aylur/dotfiles";
      inputs.ags.follows = "ags";
      inputs.astal.follows = "astal";
      inputs.home-manager.follows = "home-manager";
      inputs.hyprland.follows = "hyprland";
      inputs.hyprland-plugins.follows = "hyprland-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-end-4 = {
      url = "github:end-4/dots-hyprland";
      flake = false;
    };

    # Misc
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    devenv = {
      url = "github:cachix/devenv";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-schemas.url = "github:DeterminateSystems/flake-schemas";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    jovian.follows = "chaotic/jovian";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
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
    nu-scripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };
    nur.url = "github:nix-community/NUR";
    omnix = {
      url = "github:juspay/omnix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.snowfall-lib.follows = "snowfall-lib";
    };
    snowfall-lib = {
      url = "github:lpchaim/snowfall-lib/per-channel-config-passthrough";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils-plus.follows = "flake-utils-plus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "stable";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    overlays = with inputs; [
      chaotic.overlays.default
      nh.overlays.default
      nix-gaming.overlays.default
      nix-software-center.overlays.pkgs
      nixneovimplugins.overlays.default
      snowfall-flake.overlays.default
      (import ./overlays {inherit inputs;})
    ];
    nixosModules = with inputs; [
      chaotic.nixosModules.default
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      lanzaboote.nixosModules.lanzaboote
      nix-gaming.nixosModules.pipewireLowLatency
      nix-gaming.nixosModules.platformOptimizations
      nixos-generators.nixosModules.all-formats
      nur.nixosModules.nur
      sops-nix.nixosModules.sops
      stylix.nixosModules.stylix
    ];
    homeManagerModules = with inputs; [
      ags.homeManagerModules.default
      chaotic.homeManagerModules.default
      nix-index-database.hmModules.nix-index
      nixvim.homeManagerModules.nixvim
      sops-nix.homeManagerModules.sops
      spicetify-nix.homeManagerModules.default
      stylix.homeManagerModules.stylix
      wayland-pipewire-idle-inhibit.homeModules.default
    ];
    mkPkgs = system:
      import inputs.nixpkgs {
        inherit system overlays;
        allowUnfree = true;
      };
  in
    inputs.flake-parts.lib.mkFlake
    {inherit inputs;}
    ({
      self,
      flake-parts-lib,
      ...
    }: let
      inherit (flake-parts-lib) importApply;
    in {
      systems = import inputs.systems;
      imports = let
        importApplyWithDefaults = path:
          importApply path {inherit inputs mkPkgs self;};
      in [
        inputs.git-hooks-nix.flakeModule
        (importApply ./flake/snowfall {inherit homeManagerModules nixosModules overlays;})
        (importApplyWithDefaults ./apps)
        (importApplyWithDefaults ./devShells)
      ];
      perSystem = {
        config,
        system,
        pkgs,
        ...
      }: let
        pkgs = mkPkgs system;
      in {
        formatter = pkgs.alejandra;
        pre-commit = {
          inherit pkgs;
          check.enable = true;
          settings = {
            hooks.alejandra.enable = true;
            hooks.ripsecrets.enable = true;
          };
        };
      };
      flake.schemas = inputs.flake-schemas.schemas;
    });
}
