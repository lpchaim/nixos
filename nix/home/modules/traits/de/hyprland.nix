{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  cfg = config.my.traits.de.hyprland;
in {
  options.my.traits.de.hyprland.enable =
    lib.mkEnableOption "Hyprland DE trait"
    // {default = osConfig.my.traits.de.hyprland.enable or false;};
  config = lib.mkIf cfg.enable {
    my.modules.de.hyprland.enable = true;
  };
}
