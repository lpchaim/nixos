{
  config,
  lib,
  ...
}: let
  cfg = config.my.traits.apps.gui;
in {
  options.my.traits.apps.gui.enable = lib.mkEnableOption "GUI apps trait";
  config = lib.mkIf cfg.enable {
    my.modules.gui.enable = true;
  };
}
