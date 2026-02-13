{
  config,
  lib,
  osConfig ? {},
  pkgs,
  ...
}: let
  cfg = config.my.profiles.wayland;
in {
  options.my.profiles.wayland =
    lib.mkEnableOption "wayland profile"
    // {default = osConfig.my.profiles.wayland or false;};
  config = lib.mkIf cfg {
    home.packages = [pkgs.wl-clipboard];
    home.sessionVariables.NIXOS_OZONE_WL = "1";

    services.cliphist = {
      enable = true;
      allowImages = true;
    };
  };
}
