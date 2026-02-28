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
          identitiesOnly = false;
          identityFile = [
            "~/.ssh/id_rsa"
          ];
          setEnv = {
            TERM = "xterm-256color";
          };
        };
      };
    };

    services.ssh-agent = {
      enable = true;
    };
  };
}
