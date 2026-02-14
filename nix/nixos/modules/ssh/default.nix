{
  config,
  lib,
  ...
}: let
  cfg = config.my.ssh;
in {
  options.my.ssh.enable = lib.mkEnableOption "SSH";

  config = lib.mkIf (cfg.enable) {
    services.openssh = {
      enable = true;
      allowSFTP = true;
      openFirewall = true;
      settings = {
        AddKeysToAgent = lib.mkDefault true;
        AllowAgentForwarding = lib.mkDefault false;
        PasswordAuthentication = lib.mkDefault false;
        PermitRootLogin = lib.mkDefault false;
      };
    };
  };
}
