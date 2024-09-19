{
  config,
  lib,
  pkgs,
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
        options = import ./options.nix {inherit config;};
        optionsFile = pkgs.writeText "ags-config-json" (builtins.toJSON options);
      in {
        Install = {
          WantedBy = ["graphical-session.target"];
        };
        Service = {
          ExecStartPre = pkgs.writeShellScript "config-ags" ''
            mkdir -p ~/.cache/ags
            cp ${optionsFile} ~/.cache/ags/options.json
            chmod +w ~/.cache/ags/options.json
          '';
          ExecStart = "${ags}/bin/ags";
          Restart = "always";
          RestartSec = "5";
        };
        Unit = {
          After = ["graphical-session-pre.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
          Description = "ags";
          PartOf = ["graphical-session.target"];
          X-Restart-Triggers = [ags optionsFile];
        };
      };
    };
}
