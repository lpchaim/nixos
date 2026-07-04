{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.greeter.gdm;
in {
  options.my.profiles.greeter.gdm = lib.mkEnableOption "GDM greeter";
  config = lib.mkIf cfg {
    services.displayManager.gdm.enable = true;
  };
}
