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
    uid = osConfig.users.users.lpchaim.uid or null;
  };
}
