# Desktop-specific configurations
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.traits.formfactor.desktop;
in {
  options.my.traits.formfactor.desktop.enable = lib.mkEnableOption "desktop trait";
  config = lib.mkIf cfg.enable {
    my.traits = {
      pipewire.enable = true;
      wayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      nix-software-center
      piper
      qmk
      qmk_hid
      qmk-udev-rules
      via
      waypipe
      wayvnc
    ];

    boot.kernelPackages = pkgs.linuxPackages_cachyos;
    services.scx.enable = true; # By default uses scx_rustland scheduler

    hardware.graphics.enable = true;
    hardware.keyboard.qmk.enable = true;

    networking.firewall.allowedTCPPorts = [5900]; # Default VNC port

    powerManagement.powerUpCommands = ''
      ${pkgs.zsh}/bin/zsh -c "echo disabled > /sys/bus/usb/devices/*/power/wakeup"
    '';
  };
}
