{
  config,
  lib,
  ...
}: let
  cfg = config.my.traits.gpu.nvidia;
in {
  options.my.traits.gpu.nvidia.enable = lib.mkEnableOption "nvidia trait";
  config = lib.mkIf cfg.enable {
    boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];

    hardware = {
      graphics.enable = true;
      nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        open = false;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        powerManagement.enable = true;
      };
    };

    services.xserver.videoDrivers = ["nvidia"];
  };
}
