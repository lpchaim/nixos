{ config, lib, ... }:

let
  namespace = [ "my" "modules" "cli" "editors" "helix" ];
  cfg = lib.getAttrFromPath namespace config;
in
{
  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = lib.mkForce "catppuccin_mocha";
        editor = {
          bufferline = "always";
          color-modes = true;
          line-number = "relative";
        };
        editor.cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "block";
        };
        editor.indent-guides = {
          render = false;
          character = "╎";
          skip-levels = 1;
        };
        editor.search = {
          smart-case = true;
          wrap-around = true;
        };
        editor.statusline = {
          left = [ "mode" "spinner" "file-name" ];
          center = [ "version-control" ];
          right = [ "diagnostics" "selections" "position" "total-line-numbers" "file-encoding" ];
        };
        keys.normal = {
          "A-f" = "file_picker_in_current_buffer_directory";
          "A-ç" = "switch_to_uppercase";
          "ç" = "switch_to_lowercase";
        };
        keys.normal.space = {
          "y" = ":clipboard-yank-join";
        };
        keys.select.space = {
          "y" = ":clipboard-yank-join";
        };
      };
    };
  };
}
