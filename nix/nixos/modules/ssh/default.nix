{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.my.ssh;
in {
  options.my.ssh.enable = lib.mkEnableOption "SSH";

  config = lib.mkIf (cfg.enable) {
    programs.ssh.knownHostsFiles = [self.legacyPackages.${system}.knownHosts];
    services.openssh = {
      enable = true;
      allowSFTP = true;
      generateHostKeys = true;
      openFirewall = true;
      settings = {
        AllowAgentForwarding = lib.mkDefault false;
        PasswordAuthentication = lib.mkDefault false;
        PermitRootLogin = lib.mkDefault "no";
        KbdInteractiveAuthentication = lib.mkDefault false;
      };
    };
  };
}
