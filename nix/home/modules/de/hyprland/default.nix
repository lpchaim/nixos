{
  config,
  lib,
  pkgs,
  osConfig ? {},
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

  options.my.de.hyprland = {
    enable = lib.mkEnableOption "Hyprland customizations";
    hyprpaper.enable = lib.mkEnableOption "hyprpaper" // {default = cfg.enable;};
  };

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
            (on "hyprland.start" (
              lib.optional osConfig.my.gaming.steam.enable (exec "hl.exec_cmd" ["steam -silent" {workspace = "10 silent";}])
              ++ lib.optional osConfig.my.profiles.hardware.rgb (exec "hl.exec_cmd" ["openrgb --startminimized" {workspace = "10 silent";}])
              ++ lib.optional config.my.gui.enable (exec "hl.exec_cmd" ["vesktop" {workspace = "special:magic silent";}])
            ))
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
              snap = {
                enabled = true;
                border_overlap = true;
                respect_gaps = true;
              };
            };
            decoration = {
              rounding = 5;
              rounding_power = 4;
              active_opacity = 1;
              inactive_opacity = 0.9;
              blur = {
                enabled = true;
                size = 5;
                passes = 2;
                new_optimizations = true;
                popups = false;
                special = false;
                xray = true;
              };
              dim_inactive = true;
              dim_strength = 0.2;
              motion_blur.enabled = true;
            };
            dwindle = {
              force_split = 2; # right/bottom
              smart_split = false;
              smart_resizing = false;
              preserve_split = true;
              precise_mouse_move = true;
              use_active_for_splits = true;
            };
            master = {
              allow_small_split = true;
              mfact = "0.7";
              new_on_active = "after";
              new_status = "inherit";
            };
            misc = {
              enable_swallow = true;
              swallow_regex = "^(kitty|wezterm)$";
              disable_hyprland_logo = true;
              force_default_wallpaper = 0;
              focus_on_activate = false;
              middle_click_paste = true;
              key_press_enables_dpms = true;
              mouse_move_enables_dpms = false;
              render_unfocused_fps = 60;
              session_lock_blur = true;
              session_lock_xray = true;
              vrr = 3; # Fullscreen only for video and game content type
            };
            input = {
              kb_layout = kb.default.layout;
              kb_variant = kb.default.variant;
              kb_options = kb.default.options;
              follow_mouse = 1;
              touchpad = {
                disable_while_typing = true;
                drag_lock = true;
                natural_scroll = false;
              };
              resolve_binds_by_sym = false;
            };
            gestures = {
              workspace_swipe_cancel_ratio = 0.2;
              workspace_swipe_create_new = true;
              workspace_swipe_touch = true;
              workspace_swipe_forever = true;
            };
            cursor = {
              hide_on_key_press = true;
              hide_on_tablet = true;
              hide_on_touch = true;
              inactive_timeout = 5;
            };
            render = {
              direct_scanout = 2; # Auto for fullscreen games
            };
            ecosystem = {
              no_donation_nag = true;
              no_update_news = true;
            };
            binds = {
              hide_special_on_workspace_change = true;
              workspace_center_on = 1; # Last active
            };
            opengl.nvidia_anti_flicker = true;
            debug.disable_logs = false;
          };
          gesture = [
            {
              fingers = 2;
              direction = "swipe";
              action = "resize";
            }
            {
              fingers = 3;
              direction = "horizontal";
              action = "workspace";
            }
          ];
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
            mkGameRule = attrs:
              mkRule (attrs // {
                tag = "+game";
                border_size = 0;
                decorate = false;
                fullscreen = true;
                idle_inhibit = "always";
                immediate = true;
                no_anim = true;
                no_blur = true;
                no_dim = true;
                no_shadow = true;
                no_vrr = true;
                opaque = true;
                rounding = 0;
              });
            mkMediaAppRule = attrs:
              mkRule (attrs // {
                tag = "+media";
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
              name = "media-photo";
              match.content = "photo";
            })
            (mkMediaAppRule {
              name = "media-video";
              match.content = "video";
            })
            (mkMediaAppRule {
              name = "media-mpv";
              match.class = "^(mpv)$";
            })
            (mkMediaAppRule {
              name = "media-vlc";
              match.class = "^(vlc)$";
            })
            (mkGameRule {
              name = "game";
              match.content = "game";
            })
            (mkGameRule {
              name = "game-steam";
              match.class = ''^(steam_app_\d+)$'';
            })
            (mkRule {
              name = "modal-float";
              match.modal = true;
              float = true;
              tag = "+modal";
            })
            (mkRule {
              name = "hide-xwaylandvideobridge";
              match.class = "^(xwaylandvideobridge)$";
              max_size = "1 1";
              no_anim = true;
              no_blur = true;
              no_focus = true;
              no_initial_focus = true;
              opacity = "0.0 override";
            })
            (mkRule {
              name = "launcher-focus";
              match.class = "^(rofi)$";
              stay_focused = true;
              tag = "+launcher";
            })
          ];
        };
      };

      services = {
        hyprpaper = lib.mkIf cfg.hyprpaper.enable {
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
