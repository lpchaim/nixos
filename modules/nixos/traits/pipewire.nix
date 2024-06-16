# Use pipewire audio

{ lib, ... }:

{
  sound.enable = lib.mkForce false;
  hardware = {
    pulseaudio.enable = false;
    enableAllFirmware = true;
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };
}
