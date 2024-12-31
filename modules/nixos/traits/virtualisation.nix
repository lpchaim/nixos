{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.traits.virtualisation;
in {
  options.my.traits.virtualisation.enable = lib.mkEnableOption "virtualisation trait";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      distrobox
    ];
    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = true;
        enableNvidia = lib.elem "nvidia" config.services.xserver.videoDrivers;
      };
    };
  };
}
