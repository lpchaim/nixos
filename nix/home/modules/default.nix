{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) self;
  inherit (inputs.self.lib.loaders) listDefault;
  inherit (lib) mkDefault;
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

  my.modules = {
    cli.enable = mkDefault true;
    nix.enable = mkDefault true;
    scripts.enable = mkDefault true;
  };

  programs.home-manager.enable = lib.mkDefault true;
  systemd.user.startServices = "sd-switch";
}
