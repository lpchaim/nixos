{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.my.cli.editors.neovim.enable {
    programs.nixvim = {
      keymaps = lib.mapAttrsToList (key: attrs: attrs // {inherit key;}) {
        "R" = {
          mode = ["n" "v"];
          action = "\"_P";
          options.desc = "Replace selection";
        };
        "x" = {
          mode = ["n" "v"];
          action = "V";
          options.desc = "Extend selection to lines";
        };
        "X" = {
          mode = ["n" "v"];
          action = "V";
          options.desc = "Extend selection to lines";
        };
        "<M-d>" = {
          mode = "v";
          action = "\"_d";
          options.desc = "Delete selection without yanking";
        };
        "<M-D>" = {
          mode = "v";
          action = "\"_D";
          options.desc = "Delete selection without yanking";
        };
        "<M-c>" = {
          mode = "v";
          action = "\"_c";
          options.desc = "Replace selection without yanking";
        };
        "<M-C>" = {
          mode = "v";
          action = "\"_C";
          options.desc = "Replace selection without yanking";
        };
        "<leader>y" = {
          mode = "v";
          action = "\"+y";
          options.desc = "Yank to system clipboard";
          options.noremap = true;
        };
        "<leader>Y" = {
          mode = "n";
          action = "\"+Y";
          options.desc = "Yank remainder of line to system clipboard";
          options.noremap = true;
        };
        "<leader>p" = {
          mode = "v";
          action = "\"+p";
          options.desc = "Paste from system clipboard";
          options.noremap = true;
        };
        "<leader>P" = {
          mode = "n";
          action = "\"+P";
          options.desc = "Paste before from system clipboard";
          options.noremap = true;
        };
      };
      plugins = {
        telescope.keymaps = {
          "<leader>b" = {
            mode = "n";
            action = "buffers";
            options.desc = "Open buffer picker";
          };
          "<leader>f" = {
            mode = "n";
            action = "find_files";
            options.desc = "Open file picker";
          };
          "<leader>j" = {
            mode = "n";
            action = "jumplist";
            options.desc = "Open jumplist picker";
          };
          "<leader>?" = {
            mode = "n";
            action = "commands";
            options.desc = "Open command pallete";
          };
          "<leader>'" = {
            mode = "n";
            action = "resume";
            options.desc = "Open last picker";
          };
          "<leader>/" = {
            mode = "n";
            action = "live_grep";
            options.desc = "Search file contents";
          };
        };
      };
    };
  };
}
