{
  config,
  inputs,
  lib,
  ...
} @ args: let
  inherit (inputs.self.lib.loaders) loadNonDefault;
  cfg = config.my.modules.scripts;
in {
  options.my.modules.scripts = {
    enable = lib.mkEnableOption "scripts";
    byName = lib.mkOption {
      default = loadNonDefault ./. args;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = builtins.attrValues config.my.modules.scripts.byName;
  };
}
