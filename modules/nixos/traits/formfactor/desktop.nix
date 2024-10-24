# Desktop-specific configurations
{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../pipewire.nix
    ../wayland.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      nix-software-center
      piper
      qmk
      qmk_hid
      qmk-udev-rules
      via
      wayvnc
    ];

    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;

    hardware.graphics.enable = true;
    hardware.keyboard.qmk.enable = true;

    networking.firewall.allowedTCPPorts = [5900]; # Default VNC port

    powerManagement.powerUpCommands = ''
      ${pkgs.zsh}/bin/zsh -c "echo disabled > /sys/bus/usb/devices/*/power/wakeup"
    '';
  };
}
