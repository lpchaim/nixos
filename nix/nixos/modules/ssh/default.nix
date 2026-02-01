{
  config,
  lib,
  ...
}: let
  cfg = config.my.modules.ssh;
in {
  options.my.modules.ssh.enable = lib.mkEnableOption "SSH";

  config = lib.mkIf (cfg.enable) {
    services.openssh = {
      enable = true;
      allowSFTP = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = lib.mkDefault false;
        PermitRootLogin = lib.mkDefault "no";
      };
    };
  };
}
