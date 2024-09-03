# Desktop-specific configurations
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    piper
    qmk
    qmk_hid
    qmk-udev-rules
    via
    wayvnc
  ];

  hardware.keyboard.qmk.enable = true;

  networking.firewall.allowedTCPPorts = [5900]; # Default VNC port

  powerManagement.powerUpCommands = ''
    ${pkgs.zsh}/bin/zsh -c "echo disabled > /sys/bus/usb/devices/*/power/wakeup"
  '';
}
