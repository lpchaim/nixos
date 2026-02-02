{
  config,
  lib,
  ...
}: let
  cfg = config.my.theming;
in {
  options.my.theming.enable = lib.mkEnableOption "theming";
  config = lib.mkIf (cfg.enable) {
    stylix = {
      homeManagerIntegration = {
        autoImport = false;
        followSystem = true;
      };
      targets.plymouth.enable = false;
    };
  };
}
