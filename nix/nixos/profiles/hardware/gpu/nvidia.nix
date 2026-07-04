{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.hardware.gpu.nvidia;
in {
  options.my.profiles.hardware.gpu.nvidia = lib.mkEnableOption "NVIDIA GPU profile";
  config = lib.mkIf cfg {
    hardware = {
      graphics.enable = true;
      nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        powerManagement.enable = true;
        powerManagement.kernelSuspendNotifier = true;
      };
      nvidia-container-toolkit = {
        enable = true;
        device-name-strategy = "uuid";
        discovery-mode = "auto";
        mount-nvidia-executables = true;
        mount-nvidia-docker-1-directories = true;
      };
    };
    services.xserver.videoDrivers = ["nvidia"];

    nixpkgs.config.cudaSupport = true;
  };
}
