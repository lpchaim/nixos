{
  config,
  lib,
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
        # bufferline.enable = true;
        # dashboard.enable = true;
        # indent-blankline.enable = true;
        mini-icons.enable = true;
        mini-tabline.enable = true;
        mini-statusline.enable = true;
        mini-surround.enable = true;
        noice.enable = true;
        treesiter-textobjects.enable = true;
        # persistence.enable = true;
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
