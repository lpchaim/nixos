# Desktop-specific configurations
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.services) mkOneShotBootService;
  cfg = config.my.profiles.formfactor.desktop;
in {
  options.my.profiles.formfactor.desktop = lib.mkEnableOption "desktop profile";
  config = lib.mkIf cfg {
    my = {
      gaming.obs.enableVirtualCamera = true;
    };

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

    hardware.keyboard.qmk.enable = true;

    networking.firewall.allowedTCPPorts = [5900]; # Default VNC port

    systemd.services.usb-wakeup-disable = mkOneShotBootService {
      script = "echo disabled | tee /sys/bus/usb/devices/*/power/wakeup";
    };
  };
}
