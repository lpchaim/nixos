{
  config,
  lib,
  ...
}: let
  cfg = config.my.users;
in {
  imports = [
    ./lpchaim.nix
    ./emily.nix
  ];

  options.my.users = {
    enable = lib.mkEnableOption "user tweaks";
    defaultUserAttrs = lib.mkOption {
      default = {
        isNormalUser = true;
        extraGroups =
          ["i2c" "networkmanager" "storage" "wheel"]
          ++ lib.optionals config.programs.gamemode.enable ["gamemode"];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      mutableUsers = false;
      users.root.hashedPassword = null;
    };
  };
}
