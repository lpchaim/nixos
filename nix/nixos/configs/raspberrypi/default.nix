{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.config) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my.profiles.graphical = false;
  my.networking.tailscale.trusted = true;
  my.security.u2f.relaxed = true;

  hardware.graphics.enable = false;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nixpkgs.hostPlatform = "aarch64-linux";

  virtualisation.incus.enable = true;
  networking = {
    firewall.interfaces.incusbr0 = {
      allowedTCPPorts = [53 67];
      allowedUDPPorts = [53 67];
    };
    nftables.enable = true;
  };

  services.home-assistant = {
    enable = false;
    openFirewall = true;
    configWritable = true;
    lovelaceConfigWritable = true;
    config.homeassistant = {
      unit_system = "metric";
      temperature_unit = "C";
      time_zone = "America/Sao_Paulo";
    };
    customComponents = with pkgs.home-assistant-custom-components; [
      localtuya
      midea_ac
      midea_ac_lan
      sleep_as_android
      tuya_local
    ];
    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
      mushroom
    ];
    extraPackages = python3Packages:
      with python3Packages; [
        psycopg2
      ];
    extraComponents = [
      "default_config"
      "adguard"
      "asuswrt"
      "esphome"
      "google_translate"
      "homeassistant_hardware"
      "shopping_list"
      "tuya"
      "workday"
    ];
  };

  system.stateVersion = "24.05";
  home-manager.users.${name.user}.home.stateVersion = "24.05";
}
