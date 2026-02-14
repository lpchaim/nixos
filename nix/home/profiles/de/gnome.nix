{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  cfg = config.my.profiles.de.gnome;
in {
  options.my.profiles.de.gnome =
    lib.mkEnableOption "GNOME DE profile"
    // {default = osConfig.my.profiles.de.gnome or false;};
  config = lib.mkIf cfg {
    my.de.gnome.enable = true;
  };
}
