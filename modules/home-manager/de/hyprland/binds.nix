{ config, lib, ... }:

with lib;
let
  namespace = [ "my" "modules" "de" "hyprland" ];
  cfg = getAttrFromPath namespace config;
in
{
  wayland.windowManager.hyprland = {
    settings = {
      "$mod" = cfg.command.mod;
      "$menu" = cfg.command.menu;
      "$run" = cfg.command.run;
      "$terminal" = cfg.command.terminal;
      "$fileManager" = cfg.command.fileManager;
      "$webBrowser" = cfg.command.webBrowser;
      bind =
        let
          makeDirectional = { cmd, mods ? [ ], keys ? [ "left" "right" "up" "down" ] }:
            let
              trigger = lib.concatStringsSep " " ([ "$mod" ] ++ mods);
              directions = [ "l" "r" "u" "d" ];
            in
            (genList (i: "${trigger}, ${elemAt keys i}, ${cmd}, ${elemAt directions i}") 4);
          makeDirectionalBinds = cmd: mods:
            (makeDirectional { inherit cmd mods; })
            ++ (makeDirectional { inherit cmd mods; keys = [ "H" "L" "K" "J" ]; });
          makeWorkspaceBinds = cmd: mods:
            let
              trigger = lib.concatStringsSep " " ([ "$mod" ] ++ mods);
            in
            map
              (i:
                let
                  getKey = i: builtins.toString (if i == 10 then 0 else i);
                  getWorkspace = i: builtins.toString (i);
                in
                "${trigger}, ${getKey i}, ${cmd}, ${getWorkspace i}")
              (lib.range 1 10);
        in
        [
          ", Print, exec, grimblast copy area"
          "$mod, E, exec, $fileManager"
          "$mod, B, exec, $webBrowser"
          "$mod, T, exec, $terminal"
          "$mod, R, exec, $run"

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
      bindr = [
        "$mod, SUPER_L, exec, pkill ${lib.elemAt (lib.splitString " " cfg.command.menu) 0} || $menu"
      ];
      bindm = [
        "$mod, mouse:272, movewindow" # LMB
        "$mod, mouse:273, resizewindow" # RMB
      ];
    };
  };
}
