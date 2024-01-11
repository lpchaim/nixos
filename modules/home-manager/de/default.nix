{ config, lib, ... }:

with lib;
let
  namespace = [ "my" "modules" "de" ];
  cfg = getAttrFromPath namespace config;
in
{
  options = setAttrByPath namespace {
    enable = mkOption {
      description = "Whether to enable desktop environment tweaks.";
      type = types.bool;
      default = (flavor != null);
    };
    flavor = mkOption {
      description = "Which desktop environment to apply customizations to.";
      type = types.nullOr (types.enum [ "gnome" "plasma" ]);
      default = null;
    };
  };

  config = setAttrByPath namespace {
    gnome.enable = (cfg.flavor == "gnome");
  };

  imports = [
    ./gnome/default.nix
  ];
}
