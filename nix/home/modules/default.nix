{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) self;
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
      ./ci
      ./cli
      ./de
      ./development
      ./gui
      ./misc
      ./nix
      ./profiles
      ./scripts
      ./security
      ./ssh
      ./syncthing
      ./theming
    ];

  my = {
    cli.enable = lib.mkDefault true;
    development.enable = lib.mkDefault true;
    nix.enable = lib.mkDefault true;
    scripts.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
  };

  programs.home-manager.enable = lib.mkDefault true;
  systemd.user.startServices = "sd-switch";
}
