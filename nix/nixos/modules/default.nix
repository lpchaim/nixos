{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs) self;
  inherit (inputs.self.lib) isNvidia;
  inherit (inputs.self.lib.loaders) listDefault;
  inherit (inputs.self.lib.shared) nix;
  inherit (lib) mkDefault;
in {
  imports =
    ["${self}/nix/shared"]
    ++ (listDefault ./.)
    ++ (with inputs; [
      chaotic.nixosModules.default
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      lanzaboote.nixosModules.lanzaboote
      nix-gaming.nixosModules.pipewireLowLatency
      nix-gaming.nixosModules.platformOptimizations
      nur.modules.nixos.default
      sops-nix.nixosModules.sops
      stylix.nixosModules.stylix
    ]);

  my.profiles = {
    graphical = mkDefault true;
    wayland = mkDefault config.my.profiles.graphical;
    pipewire = mkDefault true;
    kernel = mkDefault true;
    users = mkDefault true;
  };

  nix.gc = {
    automatic = let
      nhCfg = config.programs.nh;
    in
      !nhCfg.enable || !nhCfg.clean.enable;
    dates = "weekly";
  };
  nixpkgs.config =
    nix.pkgs.config
    // {enableCuda = isNvidia config;};
}
