{
  inputs,
  lib,
  ...
}: let
  inherit (inputs.self.lib.shared.defaults) name;
in {
  home = rec {
    username = "${name.user}";
    homeDirectory = "/home/${username}";
    stateVersion = lib.mkDefault (lib.versions.majorMinor lib.version);
  };
}