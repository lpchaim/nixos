{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs) self;
  inherit (lib) mkDefault;
in {
  imports =
    (with inputs; [
      agenix.nixosModules.default
      agenix-rekey.nixosModules.default
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      lanzaboote.nixosModules.lanzaboote
      nix-gaming.nixosModules.pipewireLowLatency
      nix-gaming.nixosModules.platformOptimizations
      nur.modules.nixos.default
      stylix.nixosModules.stylix
    ])
    ++ [
      "${self}/nix/shared"
      ./boot
      ./ci
      ./desktop
      ./gaming
      ./hardware
      ./kdeconnect
      ./kernel
      ./locale
      ./networking
      ./nix
      ./pipewire
      ./programs
      ./secrets
      ./secureboot
      ./security
      ./services
      ./ssh
      ./syncthing
      ./tailscale
      ./theming
      ./users
      ./virtualization
      ./wayland
      ./zram
      ../profiles
    ];

  my = {
    kernel.enable = mkDefault true;
    networking.tailscale.enable = mkDefault true;
    nix.enable = mkDefault true;
    pipewire.enable = mkDefault true;
    secrets.enable = mkDefault true;
    security.enable = mkDefault true;
    ssh.enable = mkDefault true;
    theming.enable = mkDefault true;
    users.enable = mkDefault true;
    zram.enable = mkDefault true;
  };

  environment.systemPackages = with pkgs; [
    helix
    sbctl
    vim
    wget
  ];
  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce [];
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce [];
  };
}
