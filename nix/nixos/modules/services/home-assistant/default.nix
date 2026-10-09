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
    my.serving.ddns.subDomains = ["hass"];

    services.home-assistant = {
      enable = true;
      openFirewallForComponents = true;
      config = {
        default_config = {};
        homeassistant = {
          name = "Casa";
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
        tuya_local
      ];
      customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
        mushroom
      ];
      themes = with pkgs.home-assistant-themes; [
        material-you-theme
      ];
      extraPackages = python3Packages:
        with python3Packages; [
          gtts
          psycopg2
        ];
      extraComponents = [
        "default_config"
        "google_assistant"
        "shopping_list"
        "esphome"
        "isal"
        "matter"
        "met"
        "midea"
        "mqtt"
        "recorder"
        "tuya"
        "workday"
        "yeelight"
        "zha"
      ];
    };

    networking.firewall.allowedTCPPorts = [8123];

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

    systemd.tmpfiles.rules = let
      inherit (config.services.home-assistant) configDir;
    in [
      "f ${configDir}/automations.yaml 0644 hass hass -"
      "f ${configDir}/scenes.yaml 0644 hass hass -"
      "f ${configDir}/scripts.yaml 0644 hass hass -"
    ];
  };
}
