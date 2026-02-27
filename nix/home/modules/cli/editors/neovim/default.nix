{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.cli.editors.neovim;
in {
  imports = [
    ./treesitter.nix
  ];

  options.my.cli.editors.neovim.enable = lib.mkEnableOption "neovim";

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      globals = {
        mapleader = "<Space>";
        maplocalleader = "<Space>";
      };
      opts = {
        ignorecase = true;
        smartcase = true;
      };
      keymaps = [
        {
          mode = "";
          key = "<Space>";
          action = "<Nop>";
          options.silent = true;
          options.noremap = true;
        }
      ];
      plugins = {
        coq = {
          enable = true;
          settings.auto_start = true;
          settings.keymap.recommended = true;
        };
        dashboard.enable = true;
        indent-blankline.enable = true;
        mini-icons.enable = true;
        mini-tabline.enable = true;
        mini-statusline.enable = true;
        mini-surround.enable = true;
        noice.enable = true;
        nvim-notify.enable = true;
        treesitter = {
          enable = true;
          folding.enable = true;
          highlight.enable = true;
          indent.enable = true;
          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            bash
            nix
            regex
          ];
        };
        treesiter-textobjects = {
          enable = true;
          settings = {
            enable = true;
            keymaps = {
              "if" = "@function.inner";
              af = "@function.outer";
            };
            lookahead = true;
          };
        };
        telescope = {
          enable = true;
          keymaps = {
            "<leader>f" = {
              mode = "n";
              action = "find_files";
              options.desc = "Pick file";
            };
            "<leader>/" = {
              mode = "n";
              action = "live_grep";
              options.desc = "Search file contents";
            };
          };
        };
        web-devicons.enable = true;
        which-key.enable = true;
      };
    };
  };
}
