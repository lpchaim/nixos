{
  lib,
  config,
  osConfig ? {},
  ...
}: {
  options.my = {
    hostName = lib.mkOption {
      type = with lib.types; nullOr str;
      default = osConfig.networking.hostName or null;
    };
    deprecated =
      lib.mkEnableOption "deprecation marker"
      // {default = osConfig.my.deprecated or false;};
  };

  config = {
    assertions = [
      {
        assertion = config.my.hostName != null;
        message = "config.my.hostName must be set manually in standalone home configurations";
      }
    ];
  };
}
