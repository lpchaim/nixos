{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.my.storage;
in {
  imports = [
    ./mergerfs.nix
    ./zfs.nix
  ];

  options.my.storage = {
    configDir = lib.mkOption {
      description = "Centralized program configuration directory";
      type = lib.types.str;
      default = "/srv/storage/AppData/config";
    };
    dataDir = lib.mkOption {
      description = "Centralized program data directory";
      type = lib.types.str;
      default = "/srv/storage/AppData/data";
    };
    logDir = lib.mkOption {
      description = "Centralized program log directory";
      type = lib.types.str;
      default = "/srv/storage/AppData/log";
    };
    defaultUser = lib.mkOption {
      type = lib.types.str;
      default = self.vars.name.user;
    };
    defaultGroup = lib.mkOption {
      type = lib.types.str;
      default = self.vars.name.user;
    };
  };

  config = {
    services.smartd = {
      enable = true;
      autodetect = true;
      notifications.wall.enable = true;
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.configDir} 0755 ${cfg.defaultUser} ${cfg.defaultGroup} -"
      "d ${cfg.dataDir} 0755 ${cfg.defaultUser} ${cfg.defaultGroup} -"
      "d ${cfg.logDir} 0755 ${cfg.defaultUser} ${cfg.defaultGroup} -"
    ];
  };
}
