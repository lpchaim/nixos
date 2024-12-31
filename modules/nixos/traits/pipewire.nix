# Use pipewire audio
{
  config,
  lib,
  ...
}: let
  cfg = config.my.traits.pipewire;
in {
  options.my.traits.pipewire.enable = lib.mkEnableOption "pipewire trait";
  config = lib.mkIf cfg.enable {
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
  };
}
