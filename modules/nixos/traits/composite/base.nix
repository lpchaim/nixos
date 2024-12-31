{
  config,
  lib,
  ...
}: let
  cfg = config.my.traits.composite.base;
in {
  options.my.traits.composite.base.enable = lib.mkEnableOption "base trait";
  config = lib.mkIf cfg.enable {
    my.traits = {
      kernel.enable = true;
      users.enable = true;
    };
  };
}
