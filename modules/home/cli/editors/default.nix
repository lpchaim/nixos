{
  config,
  lib,
  ...
}: let
  cfg = config.my.modules.cli.editors;
  inherit (cfg) enable;
in {
  options.my.modules.cli.editors = {
    enable = lib.mkEnableOption "editors";
    kakoune.enable = lib.mkEnableOption "kakoune" // {inherit enable;};
    vim.enable = lib.mkEnableOption "vim" // {inherit enable;};
  };

  config = lib.mkIf cfg.enable {
    programs = {
      kakoune.enable = cfg.kakoune.enable;
      vim.enable = cfg.vim.enable;
    };
    home.sessionVariables.EDITOR = "hx";
  };
}
