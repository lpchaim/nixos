{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) self;
  inherit (lib) mkDefault;
in {
  imports =
    (with inputs; [
      caelestia.homeManagerModules.default
      chaotic.homeManagerModules.default
      nix-index-database.homeModules.nix-index
      nix-flatpak.homeManagerModules.nix-flatpak
      nixvim.homeModules.nixvim
      sops-nix.homeManagerModules.sops
      spicetify-nix.homeManagerModules.default
      stylix.homeModules.stylix
      wayland-pipewire-idle-inhibit.homeModules.default
    ])
    ++ [
      "${self}/nix/shared"
      ./cli
      ./de
      ./gui
      ./misc
      ./nix
      ./profiles
      ./scripts
      ./syncthing
      ./theming
    ];

  my.modules = {
    cli.enable = mkDefault true;
    nix.enable = mkDefault true;
    scripts.enable = mkDefault true;
  };

  programs.home-manager.enable = lib.mkDefault true;
  systemd.user.startServices = "sd-switch";
}
