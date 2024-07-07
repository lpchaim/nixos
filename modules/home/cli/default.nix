{ config, lib, ... }:

with lib;
let
  namespace = [ "my" "modules" "cli" ];
  cfg = getAttrFromPath namespace config;
in
{
  options = setAttrByPath namespace {
    enable = mkEnableOption "custom modules";
  };

  config = setAttrByPath namespace {
    editors = mkIf cfg.enable {
      enable = mkDefault true;
      helix.enable = mkDefault true;
      kakoune.enable = mkDefault true;
      neovim.enable = mkDefault true;
      vim.enable = mkDefault true;
    };
    essentials.enable = mkDefault true;
    git = {
      enable = mkDefault true;
      lazygit.enable = mkDefault true;
    };
    hishtory.enable = mkDefault true;
    just.enable = true;
    nushell.enable = mkDefault true;
    starship.enable = mkDefault true;
    tealdeer.enable = mkDefault true;
    tmux.enable = mkDefault true;
    zellij.enable = mkDefault true;
    zsh.enable = mkDefault true;
  };
}
