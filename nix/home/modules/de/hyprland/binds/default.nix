{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.lib.hyprland.lua) bind bindl bindle exec execCmd local mod;

  cfg = config.my.de.hyprland.binds;
in {
  options.my.de.hyprland.binds = {
    enable = lib.mkEnableOption "bindings";
    enableFnKeys = lib.mkEnableOption "function key bindings";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        mod = local "SUPER";
        bind =
          [
            (bind (mod "E") (execCmd "nautilus") {})
            (bind "CTRL + ALT + L" (execCmd config.services.hypridle.settings.general.lock_cmd) {})
            (bind (mod "F11") (execCmd "pidof grimblast || grimblast copy output --notify") {})
            (bind (mod "ALT + F11") (execCmd "pidof grimblast || grimblast copy active --notify") {})
            (bind (mod "SHIFT + F11") (execCmd "pidof grimblast || ${pkgs.writeShellScript "grimblast-freeze" ''
              # Workaround for grimblast --freeze not actually freezing, see https://github.com/hyprwm/contrib/issues/37#issuecomment-1558933363
              hyprpicker -r -n -z &
              hyprpicker_pid=$!
              grimblast copy area --notify
              kill "$hyprpicker_pid"
            ''}") {})

            (bind (mod "X") (exec "hl.dsp.layout" ["togglesplit"]) {})
            (bind (mod "SHIFT + X") (exec "hl.dsp.layout" ["swapsplit"]) {})

            (bind (mod "Q") (exec "hl.dsp.window.close" []) {})
            (bind (mod "F") (exec "hl.dsp.window.float" [{action = "toggle";}]) {})
            (bind (mod "SHIFT + F") (exec "hl.dsp.window.float" [{action = "set";}]) {})
            (bind (mod "SHIFT + F") (exec "hl.dsp.window.pin" []) {})
            (bind (mod "G") (exec "hl.dsp.group.toggle" []) {})
            (bind (mod "Z") (exec "hl.dsp.window.fullscreen" [{mode = "fullscreen"; action = "toggle";}]) {})

            (bind "ALT + TAB" (exec "hl.dsp.window.cycle_next" [{next = true; tiled = true;}]) {})
            (bind "ALT + SHIFT + TAB" (exec "hl.dsp.window.cycle_next" [{prev = true; tiled = true;}]) {})
            (bind (mod "TAB") (exec "hl.dsp.window.cycle_next" [{next = true;}]) {})
            (bind (mod "SHIFT + TAB") (exec "hl.dsp.window.cycle_next" [{prev = true;}]) {})

            (bind (mod "S") (exec "hl.dsp.workspace.toggle_special" ["magic"]) {})
            (bind (mod "SHIFT + S") (exec "hl.dsp.window.move" [{workspace = "special:magic";}]) {})

            (bind (mod "SHIFT + ALT + L") (exec "hl.dsp.window.move" [{monitor = "+1";}]) {})
            (bind (mod "SHIFT + ALT + H") (exec "hl.dsp.window.move" [{monitor = "-1";}]) {})

            (bind (mod "mouse:272") (exec "hl.dsp.window.drag" []) {}) # LMB
            (bind (mod "mouse:273") (exec "hl.dsp.window.resize" []) {}) # RMB
            (bind (mod "mouse_down") (exec "hl.dsp.focus" [{workspace = "e+1";}]) {})
            (bind (mod "mouse_up") (exec "hl.dsp.focus" [{workspace = "e-1";}]) {})

            (bind (mod "H") (exec "hl.dsp.focus" [{direction = "left";}]) {})
            (bind (mod "J") (exec "hl.dsp.focus" [{direction = "down";}]) {})
            (bind (mod "K") (exec "hl.dsp.focus" [{direction = "up";}]) {})
            (bind (mod "L") (exec "hl.dsp.focus" [{direction = "right";}]) {})

            (bind (mod "SHIFT + H") (exec "hl.dsp.window.move" [{into_or_create_group = "l";}]) {})
            (bind (mod "SHIFT + J") (exec "hl.dsp.window.move" [{into_or_create_group = "d";}]) {})
            (bind (mod "SHIFT + K") (exec "hl.dsp.window.move" [{into_or_create_group = "u";}]) {})
            (bind (mod "SHIFT + L") (exec "hl.dsp.window.move" [{into_or_create_group = "r";}]) {})

            (bindle (mod "CTRL + H") (exec "hl.dsp.window.resize" [{x = -10; y = 0; relative = true;}]))
            (bindle (mod "CTRL + J") (exec "hl.dsp.window.resize" [{x = 0; y = 10; relative = true;}]))
            (bindle (mod "CTRL + K") (exec "hl.dsp.window.resize" [{x = 0; y = -10; relative = true;}]))
            (bindle (mod "CTRL + L") (exec "hl.dsp.window.resize" [{x = 10; y = 0; relative = true;}]))

            (bind (mod "1") (exec "hl.dsp.focus" [{workspace = 1;}]) {})
            (bind (mod "2") (exec "hl.dsp.focus" [{workspace = 2;}]) {})
            (bind (mod "3") (exec "hl.dsp.focus" [{workspace = 3;}]) {})
            (bind (mod "4") (exec "hl.dsp.focus" [{workspace = 4;}]) {})
            (bind (mod "5") (exec "hl.dsp.focus" [{workspace = 5;}]) {})
            (bind (mod "6") (exec "hl.dsp.focus" [{workspace = 6;}]) {})
            (bind (mod "7") (exec "hl.dsp.focus" [{workspace = 7;}]) {})
            (bind (mod "8") (exec "hl.dsp.focus" [{workspace = 8;}]) {})
            (bind (mod "9") (exec "hl.dsp.focus" [{workspace = 9;}]) {})
            (bind (mod "0") (exec "hl.dsp.focus" [{workspace = 10;}]) {})

            (bind (mod "SHIFT + 1") (exec "hl.dsp.window.move" [{workspace = 1;}]) {})
            (bind (mod "SHIFT + 2") (exec "hl.dsp.window.move" [{workspace = 2;}]) {})
            (bind (mod "SHIFT + 3") (exec "hl.dsp.window.move" [{workspace = 3;}]) {})
            (bind (mod "SHIFT + 4") (exec "hl.dsp.window.move" [{workspace = 4;}]) {})
            (bind (mod "SHIFT + 5") (exec "hl.dsp.window.move" [{workspace = 5;}]) {})
            (bind (mod "SHIFT + 6") (exec "hl.dsp.window.move" [{workspace = 6;}]) {})
            (bind (mod "SHIFT + 7") (exec "hl.dsp.window.move" [{workspace = 7;}]) {})
            (bind (mod "SHIFT + 8") (exec "hl.dsp.window.move" [{workspace = 8;}]) {})
            (bind (mod "SHIFT + 9") (exec "hl.dsp.window.move" [{workspace = 9;}]) {})
            (bind (mod "SHIFT + 0") (exec "hl.dsp.window.move" [{workspace = 10;}]) {})
          ]
          ++ lib.optionals cfg.enableFnKeys [
            (bindle "XF86MonBrightnessDown" (execCmd "brightnessctl set 5%-"))
            (bindle "XF86MonBrightnessUp" (execCmd "brightnessctl set 5%+"))
            (bindle "XF86AudioRaiseVolume" (execCmd "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"))
            (bindle "XF86AudioLowerVolume" (execCmd "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"))
            (bindl "XF86AudioPlay" (execCmd "playerctl play-pause"))
            (bindl "XF86AudioNext" (execCmd "playerctl next"))
            (bindl "XF86AudioPrev" (execCmd "playerctl previous"))
            (bindl "XF86AudioMute" (execCmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
          ]
          ++ (lib.optional config.programs.firefox.enable (bind (mod "B") (execCmd "firefox") {}))
          ++ (lib.optional config.programs.kitty.enable (bind (mod "T") (execCmd "kitty") {}))
          ++ (lib.optional config.programs.wezterm.enable (bind (mod "ALT + T") (execCmd "wezterm") {}));
      };
    };

    home.packages =
      [
        pkgs.grimblast
        pkgs.nautilus
      ]
      ++ lib.optionals cfg.enableFnKeys [
        pkgs.brightnessctl
        pkgs.playerctl
      ];
  };
}
