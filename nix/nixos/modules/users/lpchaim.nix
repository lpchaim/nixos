{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.lib.secrets.helpers) mkUserSecret;
  inherit (self.vars) name shell;
  inherit (self.vars.ssh.publicKeys) perHost perYubikey;
  userName = name.user;
  cfg = config.my.users.lpchaim;
in {
  options.my.users.lpchaim.enable = lib.mkEnableOption "lpchaim user";

  config = lib.mkIf cfg.enable {
    my.secret.definitions = {
      "user.lpchaim.password" = mkUserSecret "lpchaim" "password" {};
    };

    users = {
      groups.${userName}.gid = 1000;
      users.${userName} =
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

    systemd.services.ollama.serviceConfig.ReadWritePaths = [config.users.users.${userName}.home];
  };
}
