{
  config,
  lib,
  pkgs,
  ...
}:
lib.lpchaim.mkModule {
  inherit config;
  namespace = "my.modules.cli.fish";
  description = "fish shell";
  configBuilder = cfg: {
    programs.fish = {
      inherit (config.home) shellAliases;
      enable = true;
      plugins =
        builtins.map
        (name: {
          inherit name;
          inherit (pkgs.fishPlugins.${name}) src;
        })
        [
          "fifc"
          "foreign-env"
          "pisces"
          "puffer"
        ];
    };
  };
}
