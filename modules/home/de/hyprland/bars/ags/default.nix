{
  config,
  lib,
  ...
}:
lib.lpchaim.mkModule {
  inherit config;
  description = "ags";
  namespace = "my.modules.de.hyprland.bars.ags";
  configBuilder = cfg:
    lib.mkIf cfg.enable {
      programs.ags.enable = true;
      home.sessionVariables = {
        GTK_THEME = "Adwaita-dark";
        XCURSOR_THEME = "Adwaita";
      };
      systemd.user.services.ags = let
        ags = config.programs.ags.finalPackage;
      in {
        Install = {
          WantedBy = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${ags}/bin/ags";
          Restart = "always";
          RestartSec = "5";
        };
        Unit = {
          After = ["graphical-session-pre.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
          Description = "ags";
          PartOf = ["graphical-session.target"];
          X-Restart-Triggers = [ags];
        };
      };
    };
}
