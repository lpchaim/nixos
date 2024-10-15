{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib.lpchaim.shared) defaults;

  home = "/home/${defaults.name.user}";
  sopsFile = "${inputs.self}/secrets/hosts/${config.networking.hostName}.yaml";
in
  lib.mkIf (lib.pathExists sopsFile) {
    sops.secrets = {
      "syncthing/cert" = {
        inherit sopsFile;
        mode = "0440";
      };
      "syncthing/key" = {
        inherit sopsFile;
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
      user = defaults.name.user;
      group = defaults.name.user;
      cert = config.sops.secrets."syncthing/cert".path;
      key = config.sops.secrets."syncthing/key".path;
      dataDir = "${home}/Syncthing";
      configDir = "${home}/.config/syncthing";
      settings = {
        gui.theme = "black";
        options.relaysEnabled = true;
        options.urAccepted = -1;
        startBrowser = false;
        folders = let
          allDevices = builtins.attrNames config.services.syncthing.settings.devices;
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
            versioning = null;
            devices = allDevices;
          };
          "${home}/.steam/steam/userdata/85204334/config/grid" = {
            id = "steam-custom-icons";
            label = "Steam/Custom Icons";
            type = "sendreceive";
            versioning = null;
            devices = ["desktop" "laptop" "steamdeck" "server"];
          };
        };
        devices = {
          desktop.id = "Q7UXFUW-Q4QWALL-AVBRBPW-Y2S44CV-IR4H3V4-OT2GH4V-6WCXBR4-STJXFQJ";
          desktop.name = "Desktop";
          laptop.id = "VFFQPOF-XAPVKHO-4PUSIVT-ACYNHAZ-GOQBWC6-SEYBXGE-2MBBMRS-TJRD4QL";
          laptop.name = "Laptop";
          phone.id = "PDMAJC4-SIXM4NI-UDMSLPU-3QSBSM2-ZUBLQDU-MNCR2HH-XUJIG52-PH4IKQC";
          phone.name = "Phone";
          server.id = "X5LHXQ6-NOCD2NO-RQ7FPLO-WFLLFRE-5BTTVL6-XLH3DAV-4ZIYI47-EEOVYAK";
          server.name = "Server";
          steamdeck.id = "OBZRWRW-B7DYVZC-RL5JV3D-6YNWG4O-MAIN2GY-KTEBY6V-DWQK36S-5E2O7AB";
          steamdeck.name = "Steam Deck";
        };
      };
    };
  }
