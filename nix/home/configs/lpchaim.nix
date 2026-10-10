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
    stateVersion = lib.mkIf (osConfig != {}) osConfig.system.stateVersion;
    uid = osConfig.users.users.lpchaim.uid or null;
  };
}
