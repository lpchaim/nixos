{
  config,
  lib,
  ...
}: let
  cfg = config.my.cli.editors;
  inherit (cfg) enable;
in {
  imports = [
    ./helix
    ./neovim
  ];

  options.my.cli.editors = {
    enable = lib.mkEnableOption "editors" // {default = config.my.cli.enable;};
    kakoune.enable = lib.mkEnableOption "kakoune" // {default = enable;};
    vim.enable = lib.mkEnableOption "vim" // {default = enable;};
  };

  config = lib.mkIf cfg.enable {
    programs = {
      kakoune.enable = cfg.kakoune.enable;
      vim.enable = cfg.vim.enable;
    };
    home.sessionVariables.EDITOR = "hx";
  };
}
