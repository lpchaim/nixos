{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.my.theming;
in {
  imports = [
    (self + /nix/common/theming.nix)
  ];

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
