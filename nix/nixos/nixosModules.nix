{inputs, ...}: {
  flake.nixosModules = {
    boot = ./modules/boot;
    ci = ./modules/ci;
    deploy = ./modules/deploy;
    flatpak = ../common/flatpak.nix;
    gaming = ./modules/gaming;
    gui = ./modules/gui;
    hardware = ./modules/hardware;
    kdeconnect = ./modules/kdeconnect;
    kernel = ./modules/kernel;
    locale = ./modules/locale;
    misc = ./modules/misc;
    networking = ./modules/networking;
    nix = ./modules/nix;
    pipewire = ./modules/pipewire;
    profiles = ./profiles;
    programs = ./modules/programs;
    secrets = ./modules/secrets;
    secureboot = ./modules/secureboot;
    security = ./modules/security;
    services = ./modules/services;
    serving = ./modules/serving;
    ssh = ./modules/ssh;
    storage = ./modules/storage;
    syncthing = ./modules/syncthing;
    tailscale = ./modules/tailscale;
    theming = ./modules/theming;
    users = ./modules/users;
    virtualization = ./modules/virtualization;
    wayland = ./modules/wayland;
    zram = ./modules/zram;
    external.imports = with inputs; [
      agenix.nixosModules.default
      agenix-rekey.nixosModules.default
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      lanzaboote.nixosModules.lanzaboote
      nix-flatpak.nixosModules.nix-flatpak
      nix-gaming.nixosModules.pipewireLowLatency
      nix-gaming.nixosModules.platformOptimizations
      nur.modules.nixos.default
      quadlet-nix.nixosModules.quadlet
      stylix.nixosModules.stylix
    ];
  };
}
