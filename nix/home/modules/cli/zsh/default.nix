{
  config,
  lib,
  ...
}: let
  cfg = config.my.cli.zsh;
in {
  options.my.cli.zsh.enable = lib.mkEnableOption "zsh";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      inherit (config.home) shellAliases;
      enable = true;
      autosuggestion.enable = true;
      history = {
        extended = false;
        ignoreDups = true;
      };
      dotDir = "${config.xdg.configHome}/zsh";
    };
  };
}
