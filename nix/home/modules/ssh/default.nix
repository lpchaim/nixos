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
      settings = {
        "*" = {
          AddKeysToAgent = "yes";
          Compression = false;
          ControlMaster = "no";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "no";
          ForwardAgent = false;
          HashKnownHosts = false;
          IdentitiesOnly = true;
          IdentityFile = [
            config.my.secrets.ssh.path
            config.my.secrets.ssh-yubikey-25388788.path
            config.my.secrets.ssh-yubikey-26583315.path
          ];
          ServerAliveCountMax = 3;
          ServerAliveInterval = 0;
          SetEnv.TERM = "xterm-256color";
          UserKnownHostsFile = "~/.ssh/known_hosts ~/.ssh/known_hosts_generated";
        };
        "*github.com".IdentityFile = config.my.secrets.ssh-github.path;
        "*tangled.org".IdentityFile = config.my.secrets.ssh-tangled.path;
        "*tangled.sh".IdentityFile = config.my.secrets.ssh-tangled.path;
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
