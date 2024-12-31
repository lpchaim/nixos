{
  config,
  lib,
  ...
}: let
  cfg = config.my.modules.cli.editors.neovim;
in {
  options.my.modules.cli.editors.neovim.enable =
    lib.mkEnableOption "neovim"
    // {inherit (config.my.modules.cli.editors) enable;};
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
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
