{
  config,
  lib,
  ...
}: let
  cfg = config.my.traits.de.gnome;
in {
  options.my.traits.de.gnome.enable = lib.mkEnableOption "GNOME DE trait";
  config = lib.mkIf cfg.enable {
    my.modules.de.gnome.enable = true;
  };
}
