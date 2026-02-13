{
  config,
  lib,
  ...
}: let
  cfg = config.my.cli.editors;
in {
  imports = [
    ./helix
    ./neovim
  ];

  options.my.cli.editors = {
    kakoune.enable = lib.mkEnableOption "kakoune";
    vim.enable = lib.mkEnableOption "vim";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.kakoune.enable {
      programs.kakoune = {
        enable = true;
      };
    })
    (lib.mkIf cfg.vim.enable {
      programs.vim = {
        enable = true;
      };
    })
  ];
}
