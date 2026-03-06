{
  lib,
  osConfig ? {},
  self,
  ...
}: let
  inherit (self.vars) name;
in {
  home = rec {
    username = "${name.user}";
    homeDirectory = "/home/${username}";
    stateVersion = lib.mkDefault (lib.versions.majorMinor lib.version);
    uid = osConfig.users.users.lpchaim.uid or null;
  };
}
