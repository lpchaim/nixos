{
  config,
  lib,
  ...
}: let
  cfg = config.my.modules.theming;
in {
  options.my.modules.theming.enable = lib.mkEnableOption "theming";
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
