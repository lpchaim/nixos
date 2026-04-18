{lib, ...}: {
  imports = [
    ./mergerfs.nix
    ./zfs.nix
  ];

  options.my.storage = {
    configDir = lib.mkOption {
      description = "Centralized program configuration directory";
      type = lib.types.str;
    };
    dataDir = lib.mkOption {
      description = "Centralized program data directory";
      type = lib.types.str;
    };
    logDir = lib.mkOption {
      description = "Centralized program log directory";
      type = lib.types.str;
    };
  };
}
