{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  cfg = config.my.profiles.graphical;
in {
  options.my.profiles.graphical =
    lib.mkEnableOption "graphical profile"
    // {default = osConfig.my.profiles.graphical or false;};
  config = lib.mkIf cfg {
    my = {
      bars.dank-material-shell.enable = lib.mkDefault true;
      gui.enable = true;
      gui.media.enable = true;
    };
  };
}
