{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.server;
in {
  options.my.profiles.server = lib.mkEnableOption "server profile";
  config = lib.mkIf cfg {
    my = {
      networking.tailscale.enable = true;
      networking.tailscale.trusted = true;
    };

    documentation.man.generateCaches = false;
  };
}
