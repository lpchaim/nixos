{ config, lib, pkgs, ... }:

with lib;
with (import ./lib.nix { inherit lib; });
{
  wayland.windowManager.hyprland = {
    settings = {
      "$mod" = "SUPER";
      bindr = [
        "$mod, SUPER_L, exec, pkill rofi || rofi -show drun"
        "$mod, R, exec, pkill rofi || rofi -show run"
        "$mod, W, exec, pkill rofi || rofi -show window"
      ];
      bind = [
        "$mod, T, exec, kitty"
        "$mod ALT, T, exec, wezterm"
        "$mod, B, exec, firefox"
        "$mod, E, exec, nautilus"
        "CTRL ALT, L, exec, hyprlock"
        ", Print, exec, grimblast copy area --freze"

        # "$mod CTRL, Z, pseudo," # dwindle
        "$mod, X, togglesplit," # dwindle

        "$mod, Q, killactive,"
        "$mod, F, togglefloating,"
        "$mod ALT, F, setfloating,"
        "$mod ALT, F, pin,"
        "$mod, G, togglegroup,"
        "$mod SHIFT, G, changegroupactive,"
        "$mod, Z, fullscreen,"
        "$mod ALT, Z, fakefullscreen,"

        "ALT, TAB, cyclenext, tiled"
        "ALT SHIFT, TAB, cyclenext, prev tiled"
        "$mod, TAB, cyclenext,"
        "$mod SHIFT, TAB, cyclenext, prev"

        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ]
      ++ (makeDirectionalBinds "movefocus" [ ])
      ++ (makeDirectionalBinds "movewindoworgroup" [ "SHIFT" ])
      ++ (makeWorkspaceBinds "workspace" [ ])
      ++ (makeWorkspaceBinds "movetoworkspace" [ "SHIFT" ]);
      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        "$mod CTRL, H, resizeactive, -10 0"
        "$mod CTRL, L, resizeactive, 10 0"
        "$mod CTRL, K, resizeactive, 0 -10"
        "$mod CTRL, J, resizeactive, 0 10"
      ];
      bindm = [
        "$mod, mouse:272, movewindow" # LMB
        "$mod, mouse:273, resizewindow" # RMB
      ];
      misc = {
        enable_swallow = true;
        swallow_regex = "^(kitty|wezterm)";
      };
    };
  };

  programs = {
    firefox.enable = true;
    kitty.enable = true;
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${pkgs.kitty}/bin/kitty";
      extraConfig = {
        modi = "run,drun,window";
        display-drun = "   Apps ";
        display-run = "   Run ";
        display-window = " 﩯 Window";
        lines = 5;
        font = "${config.stylix.fonts.sansSerif.name}";
        show-icons = true;
        drun-display-format = "{icon} {name}";
        location = 0;
        disable-history = false;
        hide-scrollbar = true;
        sidebar-mode = true;
      };
    };
    wezterm.enable = true;
  };

  home.packages = with pkgs; [
    gnome.nautilus
    grimblast
  ];
}
