{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.graphical;
in {
  options.my.profiles.graphical = lib.mkEnableOption "graphical profile";
  config = lib.mkIf cfg {
    my = {
      gui.enable = true;
      wayland.enable = true;
    };

    boot = {
      kernelParams = ["quiet"];
      plymouth.enable = true;
    };
    environment.systemPackages = lib.optionals (pkgs.stdenv.hostPlatform.isx86) [pkgs.via];
    hardware = {
      graphics.enable = true;
      graphics.enable32Bit = true;
    };
    networking.firewall.allowedTCPPorts = [
      57621 # spotify local discovery
      5353 # spotify cast discovery
    ];
    services.xserver.enable = lib.mkDefault true;
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
