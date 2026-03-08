{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.gui.imageEditors;
in {
  options.my.gui.imageEditors.enable = lib.mkEnableOption "gui apps";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gimp
      krita-unwrapped
    ];
  };
}
