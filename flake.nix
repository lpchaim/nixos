{
  description = "Defines my personal systems/home configs and whatnot";

  outputs = {self, ...} @ inputs:
    inputs.flake-parts.lib.mkFlake
    {inherit inputs;}
    ({flake-parts-lib, ...}: let
      inherit (flake-parts-lib) importApply;
      importApply' = path: importApply path {inherit inputs systems;};
      systems = ["aarch64-linux" "x86_64-linux"];
    in {
      inherit systems;
      imports = [
        (importApply' ./nix/apps)
        (importApply' ./nix/modules)
        (importApply' ./nix/overlays)
        (importApply' ./nix/packages)
        (importApply' ./nix/scripts)
        (importApply' ./nix/shells)
      ];
      perSystem = {
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = self.legacyPackages.${system}.pkgs;
        formatter = pkgs.alejandra;
        legacyPackages.pkgs = self.lib.mkPkgs {
          inherit system;
          inherit (inputs) nixpkgs;
        };
      };
      flake = {
        lib = import ./nix/lib {inherit inputs;};
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
    nixpkgs-hare.url = "github:lpchaim/nixpkgs/update-hare";

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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # Misc
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ez-configs = {
      url = "github:ehllie/ez-configs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-schemas.url = "github:DeterminateSystems/flake-schemas";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    make-shell.url = "github:nicknovitski/make-shell";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
