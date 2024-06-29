{
  description = "Personal NixOS flake";

  inputs = {
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
      inputs.nixpkgs.follows = "stable";
    };
    jovian = {
      follows = "chaotic/jovian";
      inputs.nixpkgs.follows = "chaotic/nixpkgs";
    };
    nix-software-center.url = "github:vlinkz/nix-software-center";
    nix-std.url = "github:chessai/nix-std";
    nur.url = "github:nix-community/NUR";
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "unstable";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
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
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      snowfall.namespace = "lpchaim";

      channels-config = {
        allowUnfree = true;
        config = { };
      };
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      overlays = with inputs; [
        chaotic.overlays.default
        jovian.overlays.default
        nixneovimplugins.overlays.default
        snowfall-flake.overlays.default
      ];

      systems.modules.nixos = with inputs; [
        chaotic.nixosModules.default
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        jovian.nixosModules.default
        nur.nixosModules.nur
        sops-nix.nixosModules.sops
        stylix.nixosModules.stylix
      ];

      homes.modules = with inputs; [
        chaotic.homeManagerModules.default
        nixvim.homeManagerModules.nixvim
        sops-nix.homeManagerModules.sops
        stylix.homeManagerModules.stylix
      ];
    };
}
