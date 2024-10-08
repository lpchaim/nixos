{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (lib.lpchaim) shared;
  namespace = ["my" "modules" "de" "hyprland"];
  cfg = getAttrFromPath namespace config;
in {
  options = setAttrByPath namespace {
    enable = mkEnableOption "Hyprland customizations";
  };

  config = mkIf cfg.enable (mkMerge [
    (setAttrByPath namespace {
      bars.ags.enable = mkDefault cfg.enable;
      bars.ags.dotfiles.aylur.enable = mkDefault cfg.bars.ags.enable;
      binds.enableFnKeys = mkDefault cfg.bars.ags.enable;
      bars.waybar.enable = mkDefault false;
      binds.enable = mkDefault cfg.enable;
      launchers.rofi.enable = mkDefault cfg.enable;
      osd.swayosd.enable = mkDefault false;
      plugins.enable = mkDefault false;
    })
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.variables = ["--all"];
        settings = {
          exec-once = [
            "hypridle"
            "hyprpaper"
            "xwaylandvideobridge"
            "[workspace 10 silent] steam -silent"
            "[workspace 10 silent] openrgb --startminimized"
          ];
          general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 2;
            "col.active_border" = mkDefault "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = mkDefault "rgba(595959aa)";
            resize_on_border = true;
            allow_tearing = true;
            layout = "dwindle";
          };
          decoration = {
            rounding = 5;
            active_opacity = 0.9;
            inactive_opacity = 0.8;
            drop_shadow = true;
            shadow_range = 4;
            shadow_render_power = 3;
            "col.shadow" = mkDefault "rgba(1a1a1aee)";
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
          animations = {
            enabled = true;
            bezier = [
              "easein, 0.42, 0, 0.58, 1"
              "easeout, 0.42, 0, 1, 1"
              "easeinout, 0, 0, 0.58, 1"
            ];
            animation = [
              "windows, 1, 2, easeinout"
              "layers, 1, 2, easeinout"
              "fade, 1, 2, easeinout"
              "border, 1, 2, easeinout"
              "borderangle, 1, 2, easeinout"
              "workspaces, 1, 4, easeinout"
            ];
          };
          dwindle = {
            pseudotile = true;
            smart_split = true;
            smart_resizing = true;
            preserve_split = true;
            no_gaps_when_only = 1;
          };
          master = {
            new_status = "master";
            no_gaps_when_only = false;
          };
          misc = {
            disable_hyprland_logo = true;
            focus_on_activate = true;
            vrr = 2; # Fullscreen only
          };
          input = {
            kb_layout = shared.kb.default.layout;
            kb_variant = shared.kb.default.variant;
            kb_options = shared.kb.default.options;
            follow_mouse = 1;
            touchpad.natural_scroll = false;
            resolve_binds_by_sym = false;
          };
          device = [
            {
              name = "keychron--keychron-link--keyboard";
              kb_layout = shared.kb.us.layout;
              kb_variant = shared.kb.us.variant;
            }
          ];
          binds.workspace_center_on = 1; # Last active
          gestures = {
            workspace_swipe = true;
            workspace_swipe_touch = true;
            workspace_swipe_create_new = false;
            workspace_swipe_forever = true;
          };
          env = [
            "XCURSOR_SIZE,32"
            "HYPRCURSOR_SIZE,32"
          ];
          monitor = [",highrr,auto,1"];
          opengl.nvidia_anti_flicker = true;
          windowrulev2 = let
            mkRules = rules: matcher:
              map (rule: "${rule},${matcher}") rules;
            mkAutoFloatRules = mkRules [
              "opacity 0.7 override"
              "noinitialfocus"
              "float"
              "pin"
              "move onscreen 100%-w-3% 100%-w-3%"
              "size 20% 20%"
            ];
          in
            (mkAutoFloatRules "class:^(firefox)$,initialTitle:^(Picture-in-Picture)$")
            ++ (mkAutoFloatRules "initialTitle:^(Picture in picture)$")
            ++ (mkAutoFloatRules "class:^(discord)$,initialTitle:^(Discord Popout)$")
            ++ (mkRules
              ["idleinhibit focus" "fullscreen" "monitor 1" "workspace 10" "opacity 1.0 override"])
            "class:^steam_app\d+$"
            ++ (mkRules
              ["maxsize 1 1" "noanim" "noblur" "nofocus" "noinitialfocus" "opacity 0.0 override"])
            "class:^(xwaylandvideobridge)$"
            ++ [
              "stayfocused, class:^(rofi)$"
            ];
          debug.disable_logs = false;
        };
      };

      services = {
        hyprpaper = {
          enable = true;
          settings = {
            ipc = "on";
            splash = false;
            preload = ["${config.stylix.image}"];
            wallpaper = [", ${config.stylix.image}"];
          };
        };
        wayland-pipewire-idle-inhibit = {
          enable = true;
          systemdTarget = "graphical-session.target";
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
          hyprpaper
          hyprpicker
          wlinhibit
          xwaylandvideobridge
        ];
      };

      xdg.portal = {
        enable = true;
        config.common.default = ["hyprland" "wlr" "gtk"];
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
      };
    }
  ]);
}
