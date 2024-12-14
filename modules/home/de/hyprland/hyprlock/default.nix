{
  config,
  lib,
  osConfig ? null,
  ...
}: let
  inherit (lib) getAttrFromPath mkIf;
  namespace = ["my" "modules" "de" "hyprland"];
  cfg = getAttrFromPath namespace config;
in
  mkIf cfg.enable {
    stylix.targets.hyprlock.enable = false;
    programs.hyprlock = {
      enable = true;
      settings = let
        inherit (config.lib.stylix) colors;
      in {
        background = {
          path =
            if (osConfig != null && (lib.elem "nvidia" osConfig.services.xserver.videoDrivers))
            then "${config.stylix.image}"
            else "screenshot";
          blur_size = 3;
          blur_passes = 2;
        };
        input-field = [
          {
            monitor = "";
            size = "300, 50";
            dots_size = 0.25;
            dots_spacing = 0.15;
            outline_thickness = 1;
            dots_center = true;
            fade_on_empty = false;
            hide_input = false;
            outer_color = "rgb(${colors.base03})";
            inner_color = "rgb(${colors.base00})";
            font_color = "rgb(${colors.base05})";
            fail_color = "rgb(${colors.base08})";
            check_color = "rgb(${colors.base0A})";
            placeholder_text = "";
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            position = "0, -120";
            halign = "center";
            valign = "center";
          }
        ];
        label = [
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
            color = ''rgba(255, 255, 255, 0.6)'';
            font_size = "120";
            font_family = config.stylix.fonts.sansSerif.name;
            position = "0, -300";
            halign = "center";
            valign = "top";
          }
        ];
      };
    };
  }
