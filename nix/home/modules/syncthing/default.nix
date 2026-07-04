{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  inherit (config.my.secret.helpers) mkHostSecret mkSecret;
  syncthingtray = config.services.syncthing.tray.package;
  cfg = config.my.syncthing;
in {
  options.my.syncthing.enable =
    lib.mkEnableOption "syncthing"
    // {default = osConfig.my.syncthing.enable or false;};

  config = lib.mkIf cfg.enable {
    my.secret.definitions = lib.mkIf (config.my.hostName != null) {
      "syncthing-password" = mkSecret "syncthing-password" {};
      "host.syncthing-cert" = mkHostSecret config "syncthing-cert" {};
      "host.syncthing-key" = mkHostSecret config "syncthing-key" {};
    };

    services.syncthing = {
      enable = true;
      tray.enable = config.my.profiles.graphical;
      cert = config.my.secrets."host.syncthing-cert".path;
      guiAddress = "0.0.0.0:8384";
      guiCredentials = {
        username = config.home.username;
        passwordFile = config.my.secrets."syncthing-password".path;
      };
      key = config.my.secrets."host.syncthing-key".path;
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        # See ~/.local/state/syncthing/config.xml
        defaults.folder = {
          minDiskFree.unit = "%";
          minDiskFree.value = "10";
          order = "oldestFirst";
        };
        gui.theme = "dark";
        options = {
          localAnnounceEnabled = true;
          relaysEnabled = true;
          startBrowser = false;
          urAccepted = -1; # For no and don't ask again
        };
        startBrowser = false;
        folders = let
          computers = ["desktop"];
          laptops = ["laptop"];
          gaming = ["steamdeck" "steamdeck-standalone"];
          phones = ["galaxyS23"];
          servers = ["raspberrypi" "server"];
          allDevices = computers ++ laptops ++ gaming ++ phones ++ servers;
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
            devices = computers ++ laptops ++ phones ++ servers;
          };
          "~/Notes/Obsidian" = {
            id = "tgnpg-efws9";
            label = "Notes/Obsidian";
            type = "sendreceive";
            versioning = trashVersioning;
            devices = computers ++ laptops ++ phones ++ servers;
          };
          "~/Notes/Work" = {
            id = "gkcpi-lubwx";
            label = "Notes/Work";
            type = "sendreceive";
            versioning = trashVersioning;
            devices = computers ++ laptops ++ phones ++ servers;
          };
          "~/.steam/steam/userdata/85204334/config/grid" = {
            id = "steam-custom-icons";
            label = "Steam/Custom Icons";
            type = "sendreceive";
            versioning = null;
            devices = computers ++ gaming ++ servers;
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
          raspberrypi.id = "XT3UPMT-4I4FJ5W-YTHHID6-GGM57IS-RE7Z7PU-FMYJMGW-T7MJVZF-3MLJTQK";
          raspberrypi.name = "Raspberry Pi";
          server.id = "X5LHXQ6-NOCD2NO-RQ7FPLO-WFLLFRE-5BTTVL6-XLH3DAV-4ZIYI47-EEOVYAK";
          server.name = "Server";
          steamdeck.id = "OBZRWRW-B7DYVZC-RL5JV3D-6YNWG4O-MAIN2GY-KTEBY6V-DWQK36S-5E2O7AB";
          steamdeck.name = "Steam Deck (deprecated)";
          steamdeck-standalone.id = "ZVNIWFX-XW3IKJH-VP33OHM-32YKAOZ-CGXRC7E-ZTA2IUP-QLXL6GY-PP5QYQS";
          steamdeck-standalone.name = "Steam Deck";
        };
      };
    };

    home.packages = [syncthingtray];
  };
}
