{
  config,
  lib,
  ...
}: let
  cfg = config.my.gui;
in {
  options.my.gui.enable = lib.mkEnableOption "GUI apps";

  config = lib.mkIf cfg.enable {
    programs = {
      localsend.enable = true;
    };
    services = {
      flatpak.enable = true;
    };
  };
}
