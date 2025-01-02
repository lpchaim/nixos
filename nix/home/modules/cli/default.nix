{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.my.modules.cli;
in {
  options.my.modules.cli.enable =
    mkEnableOption "cli modules"
    // {default = true;};

  config.my.modules.cli = mkIf cfg.enable {
    editors.enable = mkDefault true;
    essentials.enable = mkDefault true;
    fish.enable = mkDefault true;
    git = {
      enable = mkDefault true;
      lazygit.enable = mkDefault true;
    };
    hishtory.enable = mkDefault false;
    just.enable = true;
    nushell.enable = mkDefault true;
    starship.enable = mkDefault true;
    tealdeer.enable = mkDefault true;
    tmux.enable = mkDefault true;
    zellij.enable = mkDefault true;
    zsh.enable = mkDefault true;
  };
}
