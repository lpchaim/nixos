{
  config,
  lib,
  ...
}: let
  cfg = config.my.gui.kitty;
in {
  options.my.gui.kitty.enable = lib.mkEnableOption "kitty";

  config = lib.mkIf cfg.enable {
    programs.kitty.enable = true;
  };
}
