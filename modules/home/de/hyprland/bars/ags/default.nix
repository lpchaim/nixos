{ config, lib, ... }:

lib.lpchaim.mkModule {
  inherit config;
  description = "ags";
  namespace = "my.modules.de.hyprland.bars.ags";
  configBuilder = cfg: lib.mkIf cfg.enable {
    programs.ags.enable = true;
    home.sessionVariables = {
      GTK_THEME = "Adwaita-dark";
      XCURSOR_THEME = "Adwaita";
    };
    wayland.windowManager.hyprland.settings.exec-once = lib.mkBefore [ "ags" ];
  };
}
