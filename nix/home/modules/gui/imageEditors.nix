{
  config,
  lib,
  ...
}: let
  cfg = config.my.gui.imageEditors;
in {
  options.my.gui.imageEditors.enable = lib.mkEnableOption "image editors";

  config = lib.mkIf cfg.enable {
    services.flatpak.packages = [
      "org.kde.krita"
    ];
  };
}
