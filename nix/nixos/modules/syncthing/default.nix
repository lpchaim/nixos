{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs.self.lib.config) name;
  inherit (inputs.self.lib.secrets) mkHostSecret;
  cfg = config.my.syncthing;
  home = config.home-manager.users.lpchaim.home.homeDirectory;
in {
  options.my.syncthing.enable = lib.mkEnableOption "syncthing";

  config = lib.mkIf cfg.enable {
    age.secrets = {
      "host.syncthing-cert" = mkHostSecret config "syncthing-cert" {
        mode = "0440";
      };
      "host.syncthing-key" = mkHostSecret config "syncthing-key" {
        mode = "0440";
      };
    };

    systemd.services.syncthing.preStart = let
      paths = builtins.attrNames config.services.syncthing.settings.folders;
      commands = map (p: "mkdir -p '${p}'") paths;
      script = builtins.concatStringsSep "\n" commands;
    in
      script;

    services.syncthing = {
      enable = true;
      relay.enable = true;
      openDefaultPorts = true;
      user = name.user;
      group = name.user;
      cert = config.age.secrets."host.syncthing-cert".path;
      key = config.age.secrets."host.syncthing-key".path;
      dataDir = "${home}/Syncthing";
      configDir = "${home}/.config/syncthing";
      settings = {
        gui.theme = "black";
        options.relaysEnabled = true;
        options.urAccepted = -1; # For no and don't ask again
        options.localAnnounceEnabled = true;
        startBrowser = false;
        folders = let
          computers = ["desktop" "laptop" "steamdeck" "server"];
          phones = ["pixel7" "galaxyS23"];
          allDevices = computers ++ phones;
          trashVersioning = {
            type = "trashcan";
            params.cleanoutDays = "30";
          };
        in {
          "${home}/Sync" = {
            id = "default";
            label = "Default Folder";
            type = "sendreceive";
            versioning = null;
            devices = allDevices;
          };
          "${home}/Notes/Logseq" = {
            id = "6ymhp-fehcm";
            label = "Notes/Logseq";
            type = "sendreceive";
            versioning = trashVersioning;
            devices = allDevices;
          };
          "${home}/Notes/Obsidian" = {
            id = "tgnpg-efws9";
            label = "Obsidian";
            type = "sendreceive";
            versioning = trashVersioning;
            devices = allDevices;
          };
          "${home}/.steam/steam/userdata/85204334/config/grid" = {
            id = "steam-custom-icons";
            label = "Steam/Custom Icons";
            type = "sendreceive";
            versioning = null;
            devices = computers;
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
  };
}
