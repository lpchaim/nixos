{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  inherit (config.my.config) name;
in {
  home = rec {
    username = "${name.user}";
    homeDirectory = "/home/${username}";
    stateVersion = lib.mkDefault (lib.versions.majorMinor lib.version);
    uid = osConfig.users.extraUsers.lpchaim.uid or null;
  };
}
