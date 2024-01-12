{ config, lib, pkgs, ... }:

let
  namespace = [ "my" "modules" "cli" "editors" ];
  cfg = lib.getAttrFromPath namespace config;
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "editors";
    kakoune.enable = lib.mkEnableOption "kakoune";
    vim.enable = lib.mkEnableOption "vim";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      kakoune.enable = cfg.kakoune.enable;
      vim.enable = cfg.vim.enable;
    };
  };

  imports = [
    ./helix.nix
    ./neovim/default.nix
  ];
}
