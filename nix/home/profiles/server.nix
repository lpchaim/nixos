{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  cfg = config.my.profiles.server;
in {
  options.my.profiles.server =
    lib.mkEnableOption "server profile"
    // {default = osConfig.my.profiles.server or false;};
  config = lib.mkIf cfg {
    my = {
      cli.editors.neovim.enable = false;
      cli.extras.enable = false;
      development.enable = false;
    };
  };
}
