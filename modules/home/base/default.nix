{
  config,
  lib,
  ...
} @ args:
with lib; let
  inherit (lib.lpchaim) shared;
  inherit (lib.snowfall) fs;
  namespace = ["my" "modules"];
  cfg = getAttrFromPath namespace config;
in {
  imports = [
    (fs.get-file "modules/shared")
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
    nix.gc = {
      automatic = true;
      frequency = "daily";
      options = "--delete-older-than 7d";
    };
    nix.extraOptions =
      lib.optionalAttrs
      (args ? osConfig)
      args.osConfig.nix.extraOptions;
    nix.settings = shared.nix.settings;
    systemd.user.startServices = "sd-switch";
  };
}
