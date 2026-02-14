# Use pipewire audio
{
  config,
  lib,
  ...
}: let
  cfg = config.my.pipewire;
in {
  options.my.pipewire.enable = lib.mkEnableOption "pipewire tweaks";
  config = lib.mkIf cfg.enable {
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
