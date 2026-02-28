{
  config,
  lib,
  pkgs,
  self,
  osConfig ? {},
  ...
}: let
  inherit (self.lib.secrets.helpers) mkHostSecret;
  syncthingtray = config.services.syncthing.tray.package;
  cfg = config.my.syncthing;
in {
  options.my.syncthing = {
    enable =
      lib.mkEnableOption "syncthing"
      // {default = osConfig.my.syncthing.enable or false;};
    host = lib.mkOption {
      type = with lib.types; nullOr str;
      default = osConfig.networking.hostName or null;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.host != null;
        message = "config.my.syncthing.host must be set";
      }
    ];

    my.secretDefinitions = let
      owner =
        if (osConfig != {})
        then config.home.username
        else "0";
    in
      lib.mkIf (cfg.host != null) {
        "host.syncthing-cert" = mkHostSecret cfg.host "syncthing-cert" {
          inherit owner;
        };
        "host.syncthing-key" = mkHostSecret cfg.host "syncthing-key" {
          inherit owner;
        };
      };

    services.syncthing = {
      enable = true;
      tray.enable = true;
      cert = config.my.secrets."host.syncthing-cert".path;
      key = config.my.secrets."host.syncthing-key".path;
      settings = {
        gui.theme = "dark";
        options = {
          localAnnounceEnabled = true;
          relaysEnabled = true;
          urAccepted = -1; # For no and don't ask again
        };
        startBrowser = false;
        folders = let
          computers = ["desktop" "laptop" "steamdeck"];
          phones = ["galaxyS23"];
          servers = ["server"];
          allDevices = computers ++ phones ++ servers;
          trashVersioning = {
            type = "trashcan";
            params.cleanoutDays = "30";
          };
        in {
          "~/Sync" = {
            id = "default";
            label = "Default Folder";
            type = "sendreceive";
            versioning = null;
            devices = allDevices;
          };
          "~/Notes/Logseq" = {
            id = "6ymhp-fehcm";
            label = "Notes/Logseq";
            type = "sendreceive";
            versioning = trashVersioning;
            devices = allDevices;
          };
          "~/Notes/Obsidian" = {
            id = "tgnpg-efws9";
            label = "Notes/Obsidian";
            type = "sendreceive";
            versioning = trashVersioning;
            devices = allDevices;
          };
          "~/.steam/steam/userdata/85204334/config/grid" = {
            id = "steam-custom-icons";
            label = "Steam/Custom Icons";
            type = "sendreceive";
            versioning = null;
            devices = computers ++ servers;
          };
        };
        devices = {
          desktop.id = "Q7UXFUW-Q4QWALL-AVBRBPW-Y2S44CV-IR4H3V4-OT2GH4V-6WCXBR4-STJXFQJ";
          desktop.name = "Desktop";
          laptop.id = "VFFQPOF-XAPVKHO-4PUSIVT-ACYNHAZ-GOQBWC6-SEYBXGE-2MBBMRS-TJRD4QL";
          laptop.name = "Laptop";
          pixel7.id = "PDMAJC4-SIXM4NI-UDMSLPU-3QSBSM2-ZUBLQDU-MNCR2HH-XUJIG52-PH4IKQC";
          pixel7.name = "Pixel 7 Pro";
          galaxyS23.id = "DPARDTW-7LHI6VK-CRKEYI4-VK6BWWP-DMW6KOG-6LWAT4O-QFGDFPR-XVO6RAF";
          galaxyS23.name = "Galaxy S23";
          server.id = "X5LHXQ6-NOCD2NO-RQ7FPLO-WFLLFRE-5BTTVL6-XLH3DAV-4ZIYI47-EEOVYAK";
          server.name = "Server";
          steamdeck.id = "OBZRWRW-B7DYVZC-RL5JV3D-6YNWG4O-MAIN2GY-KTEBY6V-DWQK36S-5E2O7AB";
          steamdeck.name = "Steam Deck";
        };
      };
    };

    home.packages = [syncthingtray];
    systemd.user.services.syncthingtray = {
      Service.ExecStart = lib.mkForce (pkgs.writeShellScript "syncthingtray-wait" ''
        ${syncthingtray}/bin/syncthingtray --wait
      '');
    };
  };
}
