{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.my.secret.helpers) mkSecret;
  cfg = config.my.services.home-assistant;
in {
  options.my.services.home-assistant = {
    enable = lib.mkEnableOption "Home Assistant";
  };

  config = lib.mkIf cfg.enable {
    my.secret.definitions = {
      "hass-secrets" = mkSecret "hass-secrets.yaml" {
        owner = "hass";
        group = "hass";
        path = "${config.services.home-assistant.configDir}/secrets.yaml";
      };
    };
    my.serving.units.hass = {
      port = 8123;
      external.expose = true;
      webSocket.enable = true;
    };

    services.home-assistant = {
      enable = true;
      openFirewallForComponents = true;
      config = {
        default_config = {};
        homeassistant = {
          name = "Casa";
          external_url = config.my.serving.units.hass.external.url;
          unit_system = "metric";
          temperature_unit = "C";
          time_zone = config.time.timeZone;
          latitude = "!secret latitude";
          longitude = "!secret longitude";
          elevation = "!secret elevation";
        };
        recorder.db_url = "postgresql://@/hass";
        "automation ui" = "!include automations.yaml";
        "scene ui" = "!include scenes.yaml";
        "script ui" = "!include scripts.yaml";
      };
      customComponents = with pkgs.home-assistant-custom-components; [
        tuya_local
      ];
      customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
        mushroom
      ];
      themes = with pkgs.home-assistant-themes; [
        catppuccin
        material-you-theme
      ];
      extraPackages = python3Packages:
        with python3Packages; [
          babel
          gtts
          psycopg2
          pychromecast
        ];
      extraComponents = [
        "default_config"
        "apcupsd"
        "asuswrt"
        "google_assistant"
        "shopping_list"
        "esphome"
        "google_assistant_sdk"
        "google_drive"
        "isal"
        "matter"
        "met"
        "midea"
        "mqtt"
        "nut"
        "recorder"
        "sftp_storage"
        "tuya"
        "workday"
        "yeelight"
        "zha"
      ];
      configDir = "${config.my.storage.configDir}/hass";
    };

    services.postgresql = {
      ensureDatabases = ["hass"];
      ensureUsers = [
        {
          name = "hass";
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.tmpfiles.rules = let
      inherit (config.services.home-assistant) configDir;
    in [
      "f ${configDir}/automations.yaml 0644 hass hass -"
      "f ${configDir}/scenes.yaml 0644 hass hass -"
      "f ${configDir}/scripts.yaml 0644 hass hass -"
    ];
  };
}
