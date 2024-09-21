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
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "unstable";
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
      url = "github:Aylur/ags/05e0f23534fa30c1db2a142664ee8f71e38db260";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-aylur = {
      url = "github:Aylur/dotfiles";
      inputs.ags.follows = "ags";
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
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "unstable";
    };
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
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    jovian = {
      follows = "chaotic/jovian";
      inputs.nixpkgs.follows = "chaotic/nixpkgs";
    };
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
      inputs.flake-compat.follows = "flake-compat";
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
    ({flake-parts-lib, ...}: let
      inherit (flake-parts-lib) importApply;
    in {
      systems = import inputs.systems;
      imports = [
        inputs.git-hooks-nix.flakeModule
        (importApply ./flake/snowfall {inherit homeManagerModules nixosModules overlays;})
        (importApply ./devShells {inherit mkPkgs;})
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
    });
}
