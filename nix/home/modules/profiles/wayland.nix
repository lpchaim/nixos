{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  cfg = config.my.profiles.wayland;
in {
  options.my.profiles.wayland =
    lib.mkEnableOption "wayland profile"
    // {default = osConfig.my.profiles.wayland or false;};
  config = lib.mkIf cfg {
    services.cliphist = {
      enable = true;
      allowImages = true;
    };
  };
}
