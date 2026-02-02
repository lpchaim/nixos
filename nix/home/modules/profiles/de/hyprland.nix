{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  cfg = config.my.profiles.de.hyprland;
in {
  options.my.profiles.de.hyprland =
    lib.mkEnableOption "Hyprland DE profile"
    // {default = osConfig.my.profiles.de.hyprland or false;};
  config = lib.mkIf cfg {
    my.de.hyprland.enable = true;
  };
}
