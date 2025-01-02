{
  config,
  inputs,
  lib,
  osConfig ? {},
  ...
}: let
  inherit (lib) mkDefault;
  inherit (inputs.self.lib) shared;
  cfg = config.my.modules;
in {
  options.my.modules.enable =
    lib.mkEnableOption "base home config"
    // {default = true;};
  config = lib.mkIf cfg.enable {
    programs.home-manager.enable = mkDefault true;
    nix =
      {
        gc = {
          automatic = osConfig == {};
          frequency = "daily";
          options = "--delete-older-than 7d";
        };
        settings = shared.nix.settings;
      }
      // (lib.optionalAttrs (osConfig != {}) {
        inherit (osConfig.nix) extraOptions;
      });
    systemd.user.startServices = "sd-switch";
  };
}
