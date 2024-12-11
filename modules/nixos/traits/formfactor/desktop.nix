# Desktop-specific configurations
{pkgs, ...}: {
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
      waypipe
      wayvnc
    ];

    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

    hardware.graphics.enable = true;
    hardware.keyboard.qmk.enable = true;

    networking.firewall.allowedTCPPorts = [5900]; # Default VNC port

    powerManagement.powerUpCommands = ''
      ${pkgs.zsh}/bin/zsh -c "echo disabled > /sys/bus/usb/devices/*/power/wakeup"
    '';
  };
}
