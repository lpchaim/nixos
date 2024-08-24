{ config, lib, ... }:

with lib;
let
  inherit (lib.lpchaim) shared;
  namespace = [ "my" "modules" ];
  cfg = getAttrFromPath namespace config;
in
{
  imports = [
    ../../shared
  ];

  options = setAttrByPath namespace {
    enable = mkEnableOption "customizations";
  };

  config = {
    my.modules = {
      enable = mkDefault true;
      cli.enable = mkDefault true;
      de.gnome.enable = mkDefault false;
      gui.enable = mkDefault false;
    };
    programs.home-manager.enable = mkDefault true;
    nix.settings = shared.nix.settings;
    systemd.user.startServices = "sd-switch";
  };
}
