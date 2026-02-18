{
  lib,
  osConfig ? {},
  ...
}: {
  options.my.profiles.hardware.cpu.intel =
    lib.mkEnableOption "Intel CPU profile"
    // {default = osConfig.my.profiles.hardware.cpu.intel or false;};
}
