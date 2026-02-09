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
      dms.homeModules.dank-material-shell
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
      ./bars
      ./cli
      ./de
      ./development
      ./gui
      ./misc
      ./nix
      ./profiles
      ./scripts
      ./security
      ./syncthing
      ./theming
    ];

  my = {
    cli.enable = mkDefault true;
    development.enable = mkDefault true;
    nix.enable = mkDefault true;
    scripts.enable = mkDefault true;
  };

  programs.home-manager.enable = lib.mkDefault true;
  systemd.user.startServices = "sd-switch";
}
