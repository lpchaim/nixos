{
  inputs,
  lib,
  osConfig ? {},
  pkgs,
  ...
}: let
  inherit (inputs) self;
  inherit (inputs.self.lib.config) nix;
  inherit (inputs.self.lib.loaders) listDefault;
in {
  imports =
    ["${self}/nix/shared"]
    ++ (listDefault ./.)
    ++ (with inputs; [
      ags.homeManagerModules.default
      chaotic.homeManagerModules.default
      nix-index-database.hmModules.nix-index
      nixvim.homeManagerModules.nixvim
      sops-nix.homeManagerModules.sops
      spicetify-nix.homeManagerModules.default
      stylix.homeManagerModules.stylix
      wayland-pipewire-idle-inhibit.homeModules.default
    ]);

  nix.package = lib.mkForce (osConfig.nix.package or pkgs.nix);
  nixpkgs = lib.mkIf (osConfig == {} || !osConfig.home-manager.useGlobalPkgs) {
    config =
      nix.pkgs.config
      // {enableCuda = osConfig.nix.config.enableCuda or false;};
  };
}
