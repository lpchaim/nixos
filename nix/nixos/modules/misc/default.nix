{
  config,
  lib,
  self,
  ...
}: {
  options.my = {
    deprecated = lib.mkEnableOption "deprecation marker";
    hostVars = lib.mkOption {
      description = "Current host's variables";
      default = self.vars.hosts.${config.networking.hostName} or {};
    };
  };
}
