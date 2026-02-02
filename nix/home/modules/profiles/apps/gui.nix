{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.apps.gui;
in {
  options.my.profiles.apps.gui = lib.mkEnableOption "GUI apps profile";
  config = lib.mkIf cfg {
    my.gui.enable = true;
  };
}
