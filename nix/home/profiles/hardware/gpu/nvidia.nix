{
  lib,
  osConfig,
  ...
}: {
  options.my.profiles.hardware.gpu.nvidia =
    lib.mkEnableOption "NVIDIA GPU profile"
    // {default = osConfig.my.profiles.hardware.gpu.nvidia or false;};
}
