{
  config,
  lib,
  osConfig ? {},
  pkgs,
  self,
  ...
}: let
  inherit (config.my.secret.helpers) mkSecret mkHostSecret;
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.my.ssh;
in {
  options.my.ssh.enable =
    lib.mkEnableOption "SSH tweaks"
    // {default = osConfig.my.ssh.enable or false;};

  config = lib.mkIf cfg.enable {
    my.secret.definitions = {
      "ssh" = mkHostSecret config "ssh" {generator.script = "ssh-ed25519-keypair";};
      "ssh-github" = mkSecret "ssh-github" {};
      "ssh-tangled" = mkSecret "ssh-tangled" {};
      "ssh-yubikey-25388788" = mkSecret "ssh-yubikey-25388788" {};
      "ssh-yubikey-26583315" = mkSecret "ssh-yubikey-26583315" {};
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
          compression = false;
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
          forwardAgent = false;
          hashKnownHosts = false;
          identitiesOnly = true;
          identityFile = [
            config.my.secrets.ssh.path
            config.my.secrets.ssh-yubikey-25388788.path
            config.my.secrets.ssh-yubikey-26583315.path
          ];
          serverAliveCountMax = 3;
          serverAliveInterval = 0;
          setEnv.TERM = "xterm-256color";
          userKnownHostsFile = "~/.ssh/known_hosts ~/.ssh/known_hosts_generated";
        };
        "*github.com".identityFile = config.my.secrets.ssh-github.path;
        "*tangled.org".identityFile = config.my.secrets.ssh-tangled.path;
        "*tangled.sh".identityFile = config.my.secrets.ssh-tangled.path;
      };
    };

    services.ssh-agent = {
      enable = true;
    };

    home.file = {
      ".ssh/known_hosts_generated".source = self.legacyPackages.${system}.knownHosts;
    };
  };
}
