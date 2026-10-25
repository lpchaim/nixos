{
  config,
  lib,
  osConfig ? {},
  self,
  ...
}: let
  inherit (self.vars) name;
in {
  home = {
    username = lib.mkDefault name.user;
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkIf (osConfig != {}) osConfig.system.stateVersion;
    uid = osConfig.users.users.lpchaim.uid or null;
  };
}
