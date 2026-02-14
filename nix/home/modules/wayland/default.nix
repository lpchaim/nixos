{
  config,
  lib,
  osConfig ? {},
  pkgs,
  ...
}: let
  cfg = config.my.wayland;
in {
  options.my.wayland.enable =
    lib.mkEnableOption "wayland tweaks"
    // {default = osConfig.my.wayland.enable or false;};
  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.wl-clipboard];
    home.sessionVariables.NIXOS_OZONE_WL = "1";

    services.cliphist = {
      enable = true;
      allowImages = true;
    };
  };
}
