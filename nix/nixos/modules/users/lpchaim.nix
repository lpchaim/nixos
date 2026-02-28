{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.my.config) name shell;
  inherit (config.my.config.ssh.publicKeys) perHost perYubikey;
  inherit (inputs.self.lib.secrets.helpers) mkUserSecret;
  userName = name.user;
  cfg = config.my.users.lpchaim;
in {
  options.my.users.lpchaim.enable = lib.mkEnableOption "lpchaim user";

  config = lib.mkIf cfg.enable {
    my.secret.definitions = {
      "user.lpchaim.password" = mkUserSecret "lpchaim" "password" {};
    };

    users = {
      extraGroups.${userName}.gid = 1000;
      extraUsers.${userName} =
        config.my.users.defaultUserAttrs
        // {
          uid = 1000;
          home = "/home/${userName}";
          description = name.full;
          group = userName;
          shell = pkgs.${shell};
          hashedPasswordFile = "${config.my.secrets."user.lpchaim.password".path}";
          openssh.authorizedKeys.keyFiles =
            perYubikey
            // {inherit (perHost) laptop desktop;}
            |> builtins.attrValues;
        };
    };
    systemd.services.ollama.serviceConfig.ReadWritePaths = [config.users.extraUsers.${userName}.home];
  };
}
