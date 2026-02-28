{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.greeter.dms;
in {
  options.my.profiles.greeter.dms = lib.mkEnableOption "DMS greeter";
  config = lib.mkIf cfg {
    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = lib.mkDefault "hyprland";
      configHome = "/home/lpchaim";
    };
  };
}
