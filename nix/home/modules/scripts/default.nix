{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.scripts;
in {
  options.my.modules.scripts = {
    enable = lib.mkEnableOption "scripts";
    byName = lib.mkOption {
      default = inputs.self.legacyPackages.${pkgs.system}.scripts;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = builtins.attrValues config.my.modules.scripts.byName;
  };
}
