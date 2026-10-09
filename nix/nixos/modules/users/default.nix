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
      type = lib.types.submodule {
        options = {
          isNormalUser = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          extraGroups = lib.mkOption rec {
            type = with lib.types; listOf str;
            default = ["i2c" "storage" "wheel"];
            apply = lib.concat default;
          };
        };
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
