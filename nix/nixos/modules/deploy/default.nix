{
  config,
  lib,
  ...
}: {
  options.my.deploy = {
    enable =
      lib.mkEnableOption "deployment"
      // {default = !config.my.deprecated;};
  };
}
