# Desktop-specific configurations
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.formfactor.desktop;
in {
  options.my.profiles.formfactor.desktop = lib.mkEnableOption "desktop profile";
  config = lib.mkIf cfg {
    my = {
      gaming.obs.enableVirtualCamera = true;
    };

    environment.systemPackages = with pkgs; [
      panix
      piper
    ];

    boot.kernelPackages = pkgs.linuxPackages_zen;

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
    '';
  };
}
