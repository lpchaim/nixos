{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.gaming.obs;
in {
  options.my.gaming.obs = {
    enable =
      lib.mkEnableOption "OBS"
      // {default = config.my.gaming.enable;};
    enableVirtualCamera = lib.mkEnableOption "OBS virtual webcam";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          input-overlay
          obs-pipewire-audio-capture
          obs-scale-to-sound
          obs-vaapi
          obs-vkcapture
          wlrobs
        ];
      };
    })
    (lib.mkIf (cfg.enable && cfg.enableVirtualCamera) {
      programs.obs-studio.enableVirtualCamera = true;

      boot.extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback
      ];
      boot.extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
      security.polkit.enable = true;
    })
  ];
}
