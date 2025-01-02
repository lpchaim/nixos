{
  config,
  lib,
  pkgs,
  ...
} @ args: let
  cfg = config.my.modules.cli.nushell;
  nuScripts = pkgs.nu_scripts + /share/nu_scripts;
in {
  options.my.modules.cli.nushell.enable = lib.mkEnableOption "nushell";

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      configFile.text = import ./config.nix;
      envFile.text = ''
        ${builtins.readFile ./env.nu}

        ${import ./commands.nix args}

        source "${nuScripts}/modules/formats/from-env.nu"
      '';
      plugins = with pkgs.nushellPlugins; [
        formats
        polars
        query
        units
      ];
      shellAliases =
        config.programs.bash.shellAliases
        // config.home.shellAliases
        // {
          ls = "ls";
          la = "ls -a";
          ll = "ls -l";
          lla = "ls -la";
        };
    };
  };
}
