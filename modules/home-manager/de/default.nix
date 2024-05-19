{ config, lib, ... }:

with lib;
let
  namespace = [ "my" "modules" "de" ];
  cfg = getAttrFromPath namespace config;
in
{
  imports = [
    ./gnome/default.nix
  ];
}
