{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.config) name shell;
  inherit (inputs.self.lib.secrets.helpers) mkUserSecret;
  userName = name.user;
  cfg = config.my.users;
in {
  options.my.users.enable = lib.mkEnableOption "user tweaks";
  config = lib.mkIf cfg.enable {
    my.secrets = {
      "user.emily.password" = mkUserSecret "emily" "password" {};
      "user.lpchaim.password" = mkUserSecret "lpchaim" "password" {};
    };

    users = let
      defaults = {
        isNormalUser = true;
        extraGroups = ["i2c" "networkmanager" "storage" "wheel"];
      };
    in {
      mutableUsers = false;
      groups.${userName}.gid = 1000;
      groups.emily.gid = 1001;
      extraUsers = {
        ${userName} =
          defaults
          // {
            uid = 1000;
            home = "/home/${userName}";
            description = name.full;
            group = userName;
            shell = pkgs.${shell};
            hashedPasswordFile = "${config.my.secrets."user.lpchaim.password".path}";
          };
        emily =
          defaults
          // {
            uid = 1001;
            home = "/home/emily";
            description = "emily";
            group = "emily";
            shell = pkgs.fish;
            hashedPasswordFile = "${config.my.secrets."user.emily.password".path}";
          };
        root.hashedPassword = null;
      };
    };
    nix.settings.trusted-users = ["root" "@wheel"];
    systemd.services.ollama.serviceConfig.ReadWritePaths = [config.users.extraUsers.${userName}.home];
  };
}
