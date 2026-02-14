{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.hardware.cpu.intel;
in {
  options.my.profiles.hardware.cpu.intel = lib.mkEnableOption "Intel CPU profile";
  config = lib.mkIf cfg {
    hardware = {
      graphics = {
        extraPackages = with pkgs; [intel-media-driver intel-ocl intel-vaapi-driver];
        extraPackages32 = with pkgs.pkgsi686Linux; [intel-media-driver intel-vaapi-driver];
      };
      intel-gpu-tools.enable = true;
    };
    services = {
      iptsd.enable = true;
      jellyfin.transcoding.enableIntelLowPowerEncoding = true;
      throttled.enable = true;
    };
  };
}
