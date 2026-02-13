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
      ./scripts
      ./security
      ./ssh
      ./syncthing
      ./theming
      ../profiles
    ];

  my = {
    cli = {
      atuin.enable = true;
      editors = {
        helix.enable = lib.mkDefault true;
        kakoune.enable = lib.mkDefault true;
        vim.enable = lib.mkDefault true;
      };
      essentials.enable = lib.mkDefault true;
      fish.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      nushell.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
      tealdeer.enable = lib.mkDefault true;
      zellij.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };
    development = {
      nixd.enable = lib.mkDefault true;
    };
    nix.enable = lib.mkDefault true;
    security.enable = lib.mkDefault true;
    scripts.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
  };

  programs = {
    helix.defaultEditor = lib.mkDefault true;
    home-manager.enable = lib.mkDefault true;
  };

  systemd.user.startServices = "sd-switch";
}
