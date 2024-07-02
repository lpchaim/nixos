{ config, lib, pkgs, ... }:

let
  inherit (lib)
    concatStringsSep
    elemAt
    genList
    getAttrFromPath
    mkEnableOption
    mkIf
    mkMerge
    range
    setAttrByPath;

  namespace = [ "my" "modules" "de" "hyprland" "binds" ];
  cfg = getAttrFromPath namespace config;

  makeDirectional = { cmd, mods ? [ ], keys ? [ "left" "right" "up" "down" ] }:
    let
      trigger = concatStringsSep " " ([ "$mod" ] ++ mods);
      directions = [ "l" "r" "u" "d" ];
    in
    (genList (i: "${trigger}, ${elemAt keys i}, ${cmd}, ${elemAt directions i}") 4);
  makeDirectionalBinds = cmd: mods:
    (makeDirectional { inherit cmd mods; })
    ++ (makeDirectional { inherit cmd mods; keys = [ "H" "L" "K" "J" ]; });
  makeWorkspaceBinds = cmd: mods:
    let trigger = concatStringsSep " " ([ "$mod" ] ++ mods);
    in map
      (i:
        let
          getKey = i: builtins.toString (if i == 10 then 0 else i);
          getWorkspace = i: builtins.toString (i);
        in
        "${trigger}, ${getKey i}, ${cmd}, ${getWorkspace i}")
      (range 1 10);
in
{
  options = setAttrByPath namespace {
    enable = mkEnableOption "bindings";
    enableFnKeys = lib.mkEnableOption "function key bindings";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      wayland.windowManager.hyprland = {
        settings = {
          "$mod" = "SUPER";
          bind = [
            "$mod, T, exec, kitty"
            "$mod ALT, T, exec, wezterm"
            "$mod, B, exec, firefox"
            "$mod, E, exec, nautilus"
            "CTRL ALT, L, exec, pidof hyprlock || hyprlock"
            ", Print, exec, pidof grimblast || grimblast copy area --freze"

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
        wezterm.enable = true;
      };

      home.packages = with pkgs; [
        gnome.nautilus
        grimblast
      ];
    }
    (lib.mkIf cfg.enableFnKeys {
      wayland.windowManager.hyprland.settings.binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      ];
    })
  ]);
}
