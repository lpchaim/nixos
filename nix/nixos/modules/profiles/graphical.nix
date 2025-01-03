{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.graphical;
in {
  options.my.profiles.graphical = lib.mkEnableOption "graphical profile";
  config = {
    services.xserver.enable = cfg;
  };
}
