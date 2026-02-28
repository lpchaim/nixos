{
  config,
  lib,
  ...
}: let
  inherit (config.my.config.ssh) publicKeys;
  cfg = config.my.ssh;
in {
  options.my.ssh.enable = lib.mkEnableOption "SSH";

  config = lib.mkIf (cfg.enable) {
    services.openssh = {
      enable = true;
      authorizedKeysFiles = builtins.attrValues publicKeys;
      allowSFTP = true;
      openFirewall = true;
      settings = {
        AllowAgentForwarding = lib.mkDefault false;
        PasswordAuthentication = lib.mkDefault false;
        PermitRootLogin = lib.mkDefault "no";
      };
    };
  };
}
