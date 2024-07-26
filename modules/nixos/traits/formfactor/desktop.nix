# Desktop-specific configurations
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    piper
    qmk
    qmk_hid
    qmk-udev-rules
    via
  ];

  hardware.keyboard.qmk.enable = true;
}
