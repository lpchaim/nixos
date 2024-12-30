{
  config,
  lib,
  pkgs,
  ...
}:
lib.lpchaim.mkModule {
  inherit config;
  namespace = "my.modules.cli.fish";
  description = "fish shell";
  configBuilder = cfg: {
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
