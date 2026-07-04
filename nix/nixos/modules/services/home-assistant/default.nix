{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.services.home-assistant;
in {
  options.my.services.home-assistant = {
    enable = lib.mkEnableOption "Home Assistant";
  };

  config = lib.mkIf cfg.enable {
    services.home-assistant = {
      enable = true;
      openFirewall = true;
      # configWritable = true;
      # lovelaceConfigWritable = true;
      config = {
        homeassistant = {
          unit_system = "metric";
          temperature_unit = "C";
          time_zone = config.time.timeZone;
        };
        recorder.db_url = "postgresql://@/hass";
        "automation ui" = "!include automations.yaml";
        "scene ui" = "!include scenes.yaml";
        "script ui" = "!include scripts.yaml";
      };
      customComponents = with pkgs.home-assistant-custom-components; [
        localtuya
        midea_ac
        midea_ac_lan
        # sleep_as_android
        tuya_local
      ];
      customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
        mushroom
      ];
      extraPackages = python3Packages:
        with python3Packages; [
          # gtts
          psycopg2
        ];
      extraComponents = [
        # Minimal working set
        "analytics"
        "google_translate"
        "met"
        "radio_browser"
        "shopping_list"
        # Custom
        "adguard"
        "asuswrt"
        "default_config"
        "esphome"
        "homeassistant_hardware"
        "isal"
        "tuya"
        "workday"
      ];
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = ["hass"];
      ensureUsers = [
        {
          name = "hass";
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
