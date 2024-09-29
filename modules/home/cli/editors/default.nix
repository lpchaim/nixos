{
  config,
  lib,
  ...
}: let
  namespace = ["my" "modules" "cli" "editors"];
  cfg = lib.getAttrFromPath namespace config;
in {
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "editors";
    helix.enable = lib.mkEnableOption "helix";
    kakoune.enable = lib.mkEnableOption "kakoune";
    neovim.enable = lib.mkEnableOption "neovim";
    vim.enable = lib.mkEnableOption "vim";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      kakoune.enable = cfg.kakoune.enable;
      vim.enable = cfg.vim.enable;
    };
    home.sessionVariables.EDITOR = "hx";
  };
}
