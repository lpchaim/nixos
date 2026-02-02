{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.cli.fish;
in {
  options.my.cli.fish.enable = lib.mkEnableOption "fish shell";
  config = lib.mkIf cfg.enable {
    programs.fish = {
      inherit (config.home) shellAliases;
      enable = true;
      interactiveShellInit = ''
        set -U fish_greeting
        set fish_cursor_default block
        set fish_cursor_insert line
        set fish_cursor_replace underscore
        set fish_cursor_replace_one underscore
      '';
      plugins =
        builtins.map
        (name: {
          inherit name;
          inherit (pkgs.fishPlugins.${name}) src;
        })
        [
          "done"
          "fifc"
          "foreign-env"
          "pisces"
          "puffer"
        ];
    };
  };
}
