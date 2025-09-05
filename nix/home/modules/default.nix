{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) self;
  inherit (inputs.self.lib.loaders) listDefaultRecursive;
  inherit (lib) mkDefault;
in {
  imports =
    ["${self}/nix/shared"]
    ++ (listDefaultRecursive ./.)
    ++ (with inputs; [
      ags.homeManagerModules.default
      chaotic.homeManagerModules.default
      nix-index-database.homeModules.nix-index
      nixvim.homeModules.nixvim
      sops-nix.homeManagerModules.sops
      spicetify-nix.homeManagerModules.default
      stylix.homeModules.stylix
      wayland-pipewire-idle-inhibit.homeModules.default
    ]);

  my.modules = {
    cli.enable = mkDefault true;
    nix.enable = mkDefault true;
    scripts.enable = mkDefault true;
  };

  programs.home-manager.enable = lib.mkDefault true;
  systemd.user.startServices = "sd-switch";
}
