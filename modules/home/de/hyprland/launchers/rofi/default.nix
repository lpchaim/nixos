{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.de.hyprland.launchers.rofi;
in {
  options.my.modules.de.hyprland.launchers.rofi.enable = lib.mkEnableOption "rofi";

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bindr = [
      "$mod, SUPER_L, exec, pkill rofi || rofi -show drun"
      "$mod, R, exec, pkill rofi || rofi -show run"
      "$mod, W, exec, pkill rofi || rofi -show window"
    ];

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      extraConfig = {
        modes = "run,drun,window,filebrowser,recursivebrowser,ssh,keys,combi";
        modi = "run,drun,window,recursivebrowser,ssh";
        display-drun = "󰀻  Apps";
        display-recursivebrowser = "󰉋  Files";
        display-run = "  Run";
        # display-network = "󰤨   Networks";
        display-ssh = "󰯄  SSH";
        display-window = "   Windows";
        lines = 8;
        show-icons = true;
        drun-display-format = "{icon} {name}";
        location = 0;
        disable-history = false;
        hide-scrollbar = true;
        sidebar-mode = false;
      };
    };

    home.file = let
      inherit (config.lib.stylix.colors) withHashtag;
      adiCfgs = pkgs.fetchFromGitHub {
        owner = "adi1090x";
        repo = "rofi";
        rev = "3a28753b0a8fb666f4bd0394ac4b0e785577afa2";
        hash = "sha256-G3sAyIZbq1sOJxf+NBlXMOtTMiBCn6Sat8PHryxRS0w=";
      };
      newmanCfgs = pkgs.fetchFromGitHub {
        owner = "newmanls";
        repo = "rofi-themes-collection";
        rev = "22c9b43f9e54164b8a35702fffffaef4d7b16c7c";
        hash = "sha256-uNgsOaHeuTMyKbG6A4T5oHGmoONH0Ae3CbKKHFjyrH4=";
      };
    in {
      "${config.programs.rofi.configPath}".text = lib.mkMerge [
        (lib.mkBefore ''
          @import "${adiCfgs + /files/config.rasi}"
        '')
        (lib.mkAfter ''
          @import "${pkgs.writeText "rofi-colors" ''
            * {
              bg0: ${withHashtag.base00-hex};
              bg1: ${withHashtag.base01-hex};
              bg2: ${withHashtag.base05-hex};
              bg3: ${withHashtag.base06-hex};
              fg0: ${withHashtag.base05-hex};
              fg1: ${withHashtag.base04-hex};
              fg2: ${withHashtag.base05-hex};
              fg3: ${withHashtag.base04-hex};
            }
            @import "${newmanCfgs + /themes/rounded-common.rasi}"
          ''}"
        '')
      ];
    };
  };
}
