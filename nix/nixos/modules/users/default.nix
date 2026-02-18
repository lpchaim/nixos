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
        extraGroups = ["i2c" "networkmanager" "storage" "wheel"];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      mutableUsers = false;
      extraUsers.root.hashedPassword = null;
    };
  };
}
