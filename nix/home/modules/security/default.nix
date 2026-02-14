{
  config,
  lib,
  osConfig ? {},
  pkgs,
  ...
}: let
  cfg = config.my.security;
in {
  options.my.security = {
    enable =
      lib.mkEnableOption "security settings"
      // {default = osConfig.my.security.enable or false;};
  };
  config = lib.mkIf cfg.enable {
    home.packages =
      (with pkgs; [
        yubikey-manager
        yubikey-personalization
      ])
      ++ lib.optionals config.my.profiles.graphical [
        pkgs.yubioath-flutter
      ];
  };
}
