{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.my.modules.cli;
in {
  imports = [
    ./atuin
    ./editors
    ./essentials
    ./fish
    ./git
    ./hishtory
    ./just
    ./nushell
    ./starship
    ./tealdeer
    ./tmux
    ./zellij
    ./zsh
  ];

  options.my.modules.cli.enable = mkEnableOption "cli modules";

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
    tmux.enable = mkDefault false;
    zellij.enable = mkDefault true;
    zsh.enable = mkDefault true;
  };
}
