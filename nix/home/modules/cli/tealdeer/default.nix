{
  config,
  lib,
  ...
}: let
  cfg = config.my.cli.tealdeer;
in {
  options.my.cli.tealdeer.enable = lib.mkEnableOption "nushell";

  config = lib.mkIf cfg.enable {
    programs.tealdeer = {
      enable = true;
      enableAutoUpdates = true;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
      };
    };
  };
}
