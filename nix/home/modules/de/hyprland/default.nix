{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.vars) kb;
  inherit (self.lib.hyprland.lua) args exec on;
  cfg = config.my.de.hyprland;
in {
  imports = [
    ./binds
    ./hypridle
    ./hyprlock
    ./launchers
    ./osd
  ];

  options.my.de.hyprland.enable = lib.mkEnableOption "Hyprland customizations";

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      my.de.hyprland = {
        binds.enableFnKeys = lib.mkDefault cfg.enable;
        binds.enable = lib.mkDefault cfg.enable;
        hypridle.enable = lib.mkDefault cfg.enable;
        hyprlock.enable = lib.mkDefault cfg.enable;
        launchers.rofi.enable = lib.mkDefault cfg.enable;
        osd.swayosd.enable = lib.mkDefault false;
      };
    }
    {
      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";
        systemd.variables = ["--all"];
        settings = {
          on = [
            (on "hyprland.start" [
              (exec "hl.exec_cmd" ["steam -silent" {workspace = "10 silent";}])
              (exec "hl.exec_cmd" ["openrgb --startminimized" {workspace = "10 silent";}])
            ])
          ];
          config = {
            animations.enabled = true;
            general = {
              gaps_in = 2;
              gaps_out = 5;
              border_size = 2;
              col = {
                active_border = lib.mkDefault "rgb(a5aad4)";
                inactive_border = lib.mkDefault "rgb(655978)";
              };
              resize_on_border = true;
              allow_tearing = true;
              layout = "dwindle";
            };
            decoration = {
              rounding = 5;
              active_opacity = 0.9;
              inactive_opacity = 0.8;
              blur = {
                enabled = true;
                size = 10;
                passes = 3;
                noise = 0.1;
                contrast = 0.9;
                brightness = 0.8;
                vibrancy = 0.2;
                new_optimizations = true;
                popups = true;
                special = false;
                xray = true;
              };
            };
            dwindle = {
              smart_split = true;
              smart_resizing = true;
              preserve_split = true;
              precise_mouse_move = true;
            };
            master = {
              allow_small_split = true;
              mfact = "0.7";
              new_on_active = "after";
              new_status = "inherit";
            };
            misc = {
              disable_hyprland_logo = true;
              focus_on_activate = true;
              vrr = 2; # Fullscreen only
            };
            input = {
              kb_layout = kb.default.layout;
              kb_variant = kb.default.variant;
              kb_options = kb.default.options;
              follow_mouse = 1;
              touchpad.natural_scroll = false;
              resolve_binds_by_sym = false;
            };
            binds.workspace_center_on = 1; # Last active
            opengl.nvidia_anti_flicker = true;
            debug.disable_logs = false;
            misc = {
              enable_swallow = true;
              swallow_regex = "^(kitty|wezterm)$";
            };
          };
          monitor = [
            {
              output = "";
              mode = "highrr";
              position = "auto";
              scale = "1";
              vrr = 2;
            }
            {
              output = "eDP-1";
              mode = "highrr";
              position = "auto";
              scale = "1";
              vrr = 2;
            }
          ];
          device = [
            {
              name = "keychron--keychron-link--keyboard";
              kb_layout = kb.us.layout;
              kb_variant = kb.us.variant;
            }
          ];
          gesture = {
            fingers = 3;
            direction = "horizontal";
            action = "workspace";
          };
          env = [
            (args ["XCURSOR_SIZE" 32])
            (args ["HYPRCURSOR_SIZE" 32])
          ];
          curve = [
            (args ["easein" {type = "bezier"; points = [[0.42 0] [0.58 1]];}])
            (args ["easeout" {type = "bezier"; points = [[0.42 0] [1 1]];}])
            (args ["easeinout" {type = "bezier"; points = [[0 0] [0.58 1]];}])
          ];
          animation = [
            (args [{leaf = "windows"; enabled = true; speed = 2; bezier = "easeinout";}])
            (args [{leaf = "layers"; enabled = true; speed = 2; bezier = "easeinout";}])
            (args [{leaf = "fade"; enabled = true; speed = 2; bezier = "easeinout";}])
            (args [{leaf = "border"; enabled = true; speed = 2; bezier = "easeinout";}])
            (args [{leaf = "borderangle"; enabled = true; speed = 2; bezier = "easeinout";}])
            (args [{leaf = "workspaces"; enabled = true; speed = 3; bezier = "easeinout"; style = "slide";}])
            (args [{leaf = "specialWorkspace"; enabled = true; speed = 3; bezier = "easeinout"; style = "slidevert -50%";}])
          ];
          window_rule = let
            mkRule = attrs: attrs;
            mkAutoFloatRule = attrs:
              mkRule (attrs // {
                opacity = "0.7 override";
                no_initial_focus = true;
                float = true;
                pin = true;
                move = "(monitor_w-window_w-(monitor_w*0.03)) (monitor_h-window_h-(monitor_h*0.03))";
                size = "(monitor_w*0.25) (monitor_h*0.25)";
              });
            mkMediaAppRule = attrs:
              mkRule (attrs
              // {
                idle_inhibit = "focus";
                immediate = true;
                no_vrr = true;
                opaque = true;
              });
          in [
            (mkAutoFloatRule {
              name = "floating-discord";
              match = {
                class = "^(discord|vesktop)$";
                initial_title = "^(Discord Popout)$";
              };
            })
            (mkAutoFloatRule {
              name = "floating-chromium";
              match.initial_title = "^(Picture in picture)$";
            })
            (mkAutoFloatRule {
              name = "floating-firefox";
              match = {
                class = "^(Picture-in-Picture)$";
                initial_title = "^(Picture in picture)$";
              };
            })
            (mkMediaAppRule {
              name = "media-mpv";
              match.class = "^(mpv)$";
            })
            (mkMediaAppRule {
              name = "media-vlc";
              match.class = "^(vlc)$";
            })
            (mkRule {
              name = "steam-games";
              match = {
                class = "^steam_appd+$";
              };
              fullscreen = true;
              idle_inhibit = "focus";
              monitor = "1";
              opacity = "1.0 override";
              workspace = "10";
            })
            (mkRule {
              name = "hide-xwaylandvideobridge";
              match = {
                class = "^(xwaylandvideobridge)$";
              };
              max_size = "1 1";
              no_anim = true;
              no_blur = true;
              no_focus = true;
              no_initial_focus = true;
              opacity = "0.0 override";
            })
            (mkRule {
              name = "rofi-focus";
              match = {
                class = "^(rofi)$";
              };
              stay_focused = true;
            })
          ];
        };
      };

      services = {
        hyprpaper = {
          enable = true;
          systemdTarget = "hyprland-session.target";
          settings = {
            ipc = "on";
            splash = false;
            preload = ["${config.stylix.image}"];
            wallpaper = [", ${config.stylix.image}"];
          };
        };
        wayland-pipewire-idle-inhibit = {
          enable = true;
          systemdTarget = "hyprland-session.target";
          settings = {
            verbosity = "INFO";
            media_minimum_duration = 10;
            idle_inhibitor = "wayland";
            sink_whitelist = [];
            node_blacklist = [];
          };
        };
      };

      systemd.user.services.wljoywake = {
        Install = {
          WantedBy = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${pkgs.wljoywake}/bin/wljoywake -t 10";
          Restart = "always";
          RestartSec = "5";
        };
        Unit = {
          After = ["graphical-session-pre.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
          Description = "wljoywake";
          PartOf = ["graphical-session.target"];
          X-Restart-Triggers = [pkgs.wljoywake];
        };
      };

      home = {
        packages = with pkgs; [
          brightnessctl
          hyprcursor
          hyprpicker
          wlinhibit
        ];
      };
    }
  ]);
}
