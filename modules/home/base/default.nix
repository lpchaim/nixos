{
  config,
  lib,
  osConfig ? null,
  ...
}: let
  inherit (lib) mkDefault;
  inherit (lib.lpchaim) shared;
  inherit (lib.snowfall) fs;
  cfg = config.my.modules;
in {
  imports = [
    (fs.get-file "modules/shared")
  ];

  options.my.modules.enable =
    lib.mkEnableOption "root home config"
    // {enable = true;};
  config = lib.mkIf cfg.enable {
    programs.home-manager.enable = mkDefault true;
    nix =
      {
        gc = {
          automatic = osConfig == null;
          frequency = "daily";
          options = "--delete-older-than 7d";
        };
        settings = shared.nix.settings;
      }
      // (lib.optionalAttrs (osConfig != null) {
        inherit (osConfig.nix) extraOptions;
      });
    systemd.user.startServices = "sd-switch";
  };
}
