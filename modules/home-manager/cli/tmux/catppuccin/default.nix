# Docs https://github.com/catppuccin/tmux

{ config, pkgs, lib, parentNamespace, ... }:

with builtins;
with lib;
let
  namespace = [ "my" "modules" "cli" "tmux" "catppuccin" ];
  cfg = lib.getAttrFromPath namespace config;
in
{
  options = lib.setAttrByPath namespace {
    enable = mkOption {
      description = "Whether to enable catppuccin.";
      type = types.bool;
      default = false;
    };
    flavor = mkOption {
      description = "The theme to use.";
      type = types.enum [ "frappe" "macchiato" "mocha" ];
      default = "mocha";
    };
  };

  config = mkIf cfg.enable {
    programs.tmux.plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour '${cfg.flavor}'

          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"

          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"

          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"

          set -g @catppuccin_status_modules_right "host session date_time"
          set -g @catppuccin_status_left_separator  ""
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_right_separator_inverse "yes"
          set -g @catppuccin_status_fill "all"
          set -g @catppuccin_status_connect_separator "no"

          set -g @catppuccin_directory_text "#{pane_current_path}"
        '';
      }
    ];
  };
}
