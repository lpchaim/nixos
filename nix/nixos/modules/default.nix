{
  config,
  inputs,
  ...
}: let
  inherit (inputs) self;
  inherit (inputs.self.lib) isNvidia;
  inherit (inputs.self.lib.loaders) listDefault;
  inherit (inputs.self.lib.shared) nix;
in {
  imports =
    ["${self}/nix/shared"]
    ++ (listDefault ./.)
    ++ (with inputs; [
      chaotic.nixosModules.default
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      lanzaboote.nixosModules.lanzaboote
      lix-module.nixosModules.default
      nix-gaming.nixosModules.pipewireLowLatency
      nix-gaming.nixosModules.platformOptimizations
      nur.modules.nixos.default
      sops-nix.nixosModules.sops
      stylix.nixosModules.stylix
    ]);

  nix.gc = {
    automatic = (config.programs.nh.clean.enable or false) == false;
    dates = "weekly";
  };
  nixpkgs.config =
    nix.pkgs.config
    // {enableCuda = isNvidia config;};
}
