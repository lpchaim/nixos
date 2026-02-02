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

  options.my.cli.editors.neovim.enable =
    lib.mkEnableOption "neovim"
    // {default = config.my.cli.editors.enable;};

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
