{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.cli.nushell;
  nuScripts = pkgs.nu_scripts + /share/nu_scripts;
in {
  options.my.cli.nushell.enable = lib.mkEnableOption "nushell";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [fzf];
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
      envFile.text = ''
        source ${./env.nu}
        source ${./commands.nu}
        source "${nuScripts}/modules/formats/from-env.nu"
      '';
      plugins = with pkgs.nushellPlugins; [
        query
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
