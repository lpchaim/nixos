{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  cfg = config.my.ssh;
in {
  options.my.ssh.enable =
    lib.mkEnableOption "SSH tweaks"
    // {default = osConfig.my.ssh.enable or false;};

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
          identitiesOnly = true;
          identityFile =
            lib.optionals
            config.my.security.enable
            config.my.security.residentKeys.all;
          # ++ [
          #   "~/.ssh/id_ed25519"
          #   "~/.ssh/id_rsa"
          # ];
        };
      };
    };

    services.ssh-agent = {
      enable = true;
    };
  };
}
