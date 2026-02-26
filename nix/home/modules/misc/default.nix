{
  lib,
  osConfig ? {},
  ...
}: {
  options.my.deprecated =
    lib.mkEnableOption "deprecation marker"
    // {default = osConfig.my.deprecated or false;};
}
