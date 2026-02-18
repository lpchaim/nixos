{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.secrets.helpers) mkUserSecret;
  cfg = config.my.users.emily;
in {
  options.my.users.emily.enable = lib.mkEnableOption "emily user";

  config = lib.mkIf cfg.enable {
    my.secretDefinitions = {
      "user.emily.password" = mkUserSecret "emily" "password" {};
    };

    users = {
      extraGroups.emily.gid = 1001;
      extraUsers.emily =
        config.my.users.defaultUserAttrs
        // {
          uid = 1001;
          home = "/home/emily";
          description = "emily";
          group = "emily";
          shell = pkgs.fish;
          hashedPasswordFile = "${config.my.secrets."user.emily.password".path}";
        };
    };
  };
}
