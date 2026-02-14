{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.hardware.gpu.nvidia;
in {
  options.my.profiles.hardware.gpu.nvidia = lib.mkEnableOption "nvidia profile";
  config = lib.mkIf cfg {
    boot.kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
      "nvidia.NVreg_UsePageAttributeTable=1"
    ];

    hardware = {
      graphics.enable = true;
      nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        open = false;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        powerManagement.enable = true;
      };
    };
    services.xserver.videoDrivers = ["nvidia"];

    nixpkgs.config.cudaSupport = true;
    virtualisation.docker.enableNvidia = true;
    virtualisation.docker.daemon.settings.features.cdi = true;
  };
}
