{
  config,
  lib,
  ...
}: let
  cfg = config.my.cli.editors.helix;
in {
  options.my.cli.editors.helix.enable = lib.mkEnableOption "helix";

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        editor = {
          bufferline = "always";
          color-modes = true;
          line-number = "relative";
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "block";
          };
          file-picker = {
            hidden = false;
          };
          indent-guides = {
            render = false;
            character = "╎";
            skip-levels = 1;
          };
          search = {
            smart-case = true;
            wrap-around = true;
          };
          statusline = {
            left = ["mode" "spinner" "file-name"];
            center = ["version-control"];
            right = ["diagnostics" "selections" "position" "total-line-numbers" "file-encoding"];
          };
        };
        keys = rec {
          normal = {
            "A-ç" = "switch_to_uppercase";
            "ç" = "switch_to_lowercase";
            "A-w" = "move_next_sub_word_start";
            "A-b" = "move_prev_sub_word_start";
            "A-e" = "move_next_sub_word_end";
            space = {
              "A-f" = "file_picker_in_current_buffer_directory";
            };
          };
          select = {
            inherit (normal) space;
            "A-w" = "extend_next_sub_word_start";
            "A-b" = "extend_prev_sub_word_start";
            "A-e" = "extend_next_sub_word_end";
          };
        };
      };
    };
  };
}
