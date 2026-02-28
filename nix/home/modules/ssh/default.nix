{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  inherit (config.my.secret.helpers) mkSecret;
  cfg = config.my.ssh;
in {
  options.my.ssh.enable =
    lib.mkEnableOption "SSH tweaks"
    // {default = osConfig.my.ssh.enable or false;};

  config = lib.mkIf cfg.enable {
    my.secret.definitions = {
      "ssh-github" = mkSecret "ssh-github" {};
      "ssh-nix" = mkSecret "ssh-nix" {};
      "ssh-tangled" = mkSecret "ssh-tangled" {};
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
          compression = false;
          forwardAgent = false;
          identitiesOnly = false;
          identityFile = [
            "~/.ssh/id_ed25519"
            "~/.ssh/id_rsa"
          ];
          setEnv = {
            TERM = "xterm-256color";
          };
        };
        "*.github.com".identityFile = config.my.secrets.ssh-github.path;
        "*.tangled.com".identityFile = config.my.secrets.ssh-tangled.path;
      };
    };

    services.ssh-agent = {
      enable = true;
    };
  };
}
