{
  config,
  lib,
  ...
}: let
  cfg = config.my.traits.de.hyprland;
in {
  options.my.traits.de.hyprland.enable = lib.mkEnableOption "Hyprland DE trait";
  config = lib.mkIf cfg.enable {
    my.modules.de.hyprland.enable = true;
  };
}
