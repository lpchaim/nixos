{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  cfg = config.my.profiles.headless;
in {
  options.my.profiles.headless =
    lib.mkEnableOption "headless profile"
    // {default = osConfig.my.profiles.headless or false;};
  config = lib.mkIf cfg {
    stylix.cursor = lib.mkForce null;
  };
}
