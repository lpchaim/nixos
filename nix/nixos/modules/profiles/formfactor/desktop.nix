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
    my.gaming.obs.enableVirtualWebcam = true;

    environment.systemPackages = with pkgs; [
      piper
      qmk
      qmk_hid
      qmk-udev-rules
      via
      waypipe
      wayvnc
    ];

    boot.kernelPackages = pkgs.linuxPackages_zen;

    hardware.graphics.enable = true;
    hardware.keyboard.qmk.enable = true;

    networking.firewall.allowedTCPPorts = [5900]; # Default VNC port

    powerManagement.powerUpCommands = ''
      ${pkgs.zsh}/bin/zsh -c "echo disabled > /sys/bus/usb/devices/*/power/wakeup"
    '';
  };
}
