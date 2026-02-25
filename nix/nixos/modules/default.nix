{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports =
    (with inputs; [
      agenix.nixosModules.default
      agenix-rekey.nixosModules.default
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      lanzaboote.nixosModules.lanzaboote
      nix-flatpak.nixosModules.nix-flatpak
      nix-gaming.nixosModules.pipewireLowLatency
      nix-gaming.nixosModules.platformOptimizations
      nur.modules.nixos.default
      stylix.nixosModules.stylix
    ])
    ++ [
      ../../shared
      ../profiles
      ./boot
      ./ci
      ./desktop
      ./gaming
      ./gui
      ./hardware
      ./kdeconnect
      ./kernel
      ./locale
      ./misc
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
    ];

  my = {
    kernel.enable = lib.mkDefault true;
    networking.tailscale.enable = lib.mkDefault true;
    nix.enable = lib.mkDefault true;
    pipewire.enable = lib.mkDefault true;
    security.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
    syncthing.enable = lib.mkDefault true;
    theming.enable = lib.mkDefault true;
    users.enable = lib.mkDefault true;
    users.lpchaim.enable = lib.mkDefault true;
    zram.enable = lib.mkDefault true;
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
