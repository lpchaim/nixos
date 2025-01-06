{
  config,
  inputs,
  lib,
  pkgs,
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
      chaotic.nixosModules.default
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      lanzaboote.nixosModules.lanzaboote
      nix-gaming.nixosModules.pipewireLowLatency
      nix-gaming.nixosModules.platformOptimizations
      nur.modules.nixos.default
      sops-nix.nixosModules.sops
      stylix.nixosModules.stylix
    ]);

  my.profiles = {
    graphical = mkDefault true;
    wayland = mkDefault config.my.profiles.graphical;
    pipewire = mkDefault true;
    kernel = mkDefault true;
    users = mkDefault true;
  };
  my.modules = {
    nix.enable = mkDefault true;
    theming.enable = mkDefault true;
    zram.enable = mkDefault true;
  };
  my.networking.tailscale.enable = mkDefault true;
  my.security.enable = mkDefault true;

  environment.systemPackages = with pkgs; [
    android-udev-rules
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
