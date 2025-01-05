{
  description = "Defines my personal systems/home configs and whatnot";

  outputs = {self, ...} @ inputs: let
    inherit (inputs.nixpkgs) lib;
    inherit (self.lib) mkPkgs;
  in
    inputs.flake-parts.lib.mkFlake
    {inherit inputs;}
    ({
      self,
      flake-parts-lib,
      ...
    }: let
      inherit (flake-parts-lib) importApply;
      importApply' = path: importApply path {inherit inputs systems;};
      systems = ["aarch64-linux" "x86_64-linux"];
    in {
      inherit systems;
      imports = [
        (importApply' ./nix/apps)
        (importApply' ./nix/modules)
        (importApply' ./nix/packages)
        (importApply' ./nix/shells)
      ];
      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
      };
      flake = {
        lib = import ./nix/lib {inherit inputs;};
        pkgs = lib.genAttrs systems (system: mkPkgs {inherit system;});
        schemas =
          inputs.flake-schemas.schemas
          // (import ./nix/schemas {inherit inputs systems;});
      };
    });

  inputs = {
    # Nixpkgs
    nixpkgs.follows = "unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-schemas.url = "github:DeterminateSystems/nix-src/flake-schemas";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixneovimplugins = {
      url = "github:jooooscha/nixpkgs-vim-extra-plugins";
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
    ags.url = "github:Aylur/ags";
    ags18.url = "github:Aylur/ags/v1.8.2";
    astal.url = "github:Aylur/astal";
    dotfiles-aylur = {
      url = "github:Aylur/dotfiles/pre-astal";
      inputs.ags.follows = "ags";
      inputs.astal.follows = "astal";
      inputs.home-manager.follows = "home-manager";
      inputs.hyprland.follows = "hyprland";
      inputs.hyprland-plugins.follows = "hyprland-plugins";
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
    ez-configs = {
      url = "github:ehllie/ez-configs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-schemas.url = "github:DeterminateSystems/flake-schemas";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.flake-compat.follows = "flake-compat";
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
    nix-std.url = "github:chessai/nix-std";
    nur.url = "github:nix-community/NUR";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
