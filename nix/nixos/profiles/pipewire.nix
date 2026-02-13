# Use pipewire audio
{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.pipewire;
in {
  options.my.profiles.pipewire = lib.mkEnableOption "pipewire profile";
  config = lib.mkIf cfg {
    hardware.enableAllFirmware = true;
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
    services.pulseaudio.enable = false;
  };
}
