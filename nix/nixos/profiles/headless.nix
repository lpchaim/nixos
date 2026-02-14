{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.headless;
in {
  options.my.profiles.headless = lib.mkEnableOption "headless profile";
  config = lib.mkIf cfg {
    my = {
      security.u2f.relaxed = true;
      profiles.graphical = false;
    };
  };
}
