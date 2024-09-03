{
  config,
  lib,
  ...
}:
with lib; let
  namespace = ["my" "modules" "de" "hyprland"];
  cfg = getAttrFromPath namespace config;
in
  mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = let
        colors = config.lib.stylix.colors;
        makeRgb = colorIndex: let
          r = colors."base${colorIndex}-rgb-r";
          g = colors."base${colorIndex}-rgb-g";
          b = colors."base${colorIndex}-rgb-b";
        in "rgb(${r},${g},${b})";
      in {
        background = {
          path = "screenshot";
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
            font_color = "rgb(0, 0, 0)";
            inner_color = "rgba(200, 200, 200, 0.5)";
            outer_color = "rgb(0, 0, 0)";
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
