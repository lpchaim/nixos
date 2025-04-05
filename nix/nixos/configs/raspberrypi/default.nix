{
  config,
  pkgs,
  ...
}: let
  inherit (config.my.config) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    ci.build = true;
    networking.tailscale.trusted = true;
    security.u2f.relaxed = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  nixpkgs.hostPlatform = "aarch64-linux";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILr9pl4qaL/+DV//lhE5y6V7xJ2eh1BSlwNYD9L9a2sQ";

  virtualisation.incus.enable = false;
  networking = {
    firewall.interfaces.incusbr0 = {
      allowedTCPPorts = [53 67];
      allowedUDPPorts = [53 67];
    };
    firewall.trustedInterfaces = ["incusbr0"];
    nftables.enable = true;
  };
  users.users.lpchaim.extraGroups = ["incus-admin"];

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
