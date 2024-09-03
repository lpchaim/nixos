{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
with lib; let
  namespace = ["my" "modules" "cli" "tmux" "tmux-powerline"];
  cfg = lib.getAttrFromPath namespace config;
in {
  options = lib.setAttrByPath namespace {
    enable = mkOption {
      description = "Whether to enable tmux-powerline.";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.tmux.plugins = with pkgs.tmuxPlugins; [
      (mkTmuxPlugin {
        pluginName = "tmux-powerline";
        version = "v3.0.0";
        rtpFilePath = "main.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "erikw";
          repo = "tmux-powerline";
          rev = "2480e5531e0027e49a90eaf540f973e624443937";
          sha256 = "sha256-25uG7OI8OHkdZ3GrTxG1ETNeDtW1K+sHu2DfJtVHVbk=";
        };
      })
    ];

    home.file."${config.xdg.configHome}/tmux-powerline/config.sh".source = ./config.sh;
    home.file."${config.xdg.configHome}/tmux-powerline/themes" = {
      source = ./themes;
      recursive = true;
    };
    home.file."${config.xdg.configHome}/tmux-powerline/segments" = {
      source = ./segments;
      recursive = true;
    };
  };
}
