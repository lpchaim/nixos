{
  config,
  lib,
  ...
}:
lib.lpchaim.mkModule {
  inherit config;
  namespace = "my.modules.cli.fish";
  description = "fish shell";
  configBuilder = cfg: {
    programs.fish = {
      enable = true;
      inherit (config.home) shellAliases;
    };
  };
}
