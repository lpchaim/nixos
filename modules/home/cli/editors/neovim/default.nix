{ config, lib, ... }:

let
  namespace = [ "my" "modules" "cli" "editors" "neovim" ];
  cfg = lib.getAttrFromPath namespace config;
in
{
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          transparent_background = false;
        };
      };
      globals = {
        mapleader = "<Space>";
      };
      plugins = {
        # bufferline.enable = true;
        # dashboard.enable = true;
        # indent-blankline.enable = true;
        noice.enable = true;
        # persistence.enable = true;
        # telescope.enable = true;
        # tmux-navigator.enable = true;
        which-key.enable = true;
      };
    };
  };
}
