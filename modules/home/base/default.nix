{
  config,
  lib,
  osConfig ? null,
  ...
}: let
  inherit (lib) mkDefault;
  inherit (lib.lpchaim) shared;
  inherit (lib.snowfall) fs;
in
  lib.lpchaim.mkModule {
    inherit config;
    description = "root home config";
    namespace = "my.modules";
    imports = [
      (fs.get-file "modules/shared")
    ];
    configBuilder = cfg: {
      my.modules = {
        enable = mkDefault true;
        cli.enable = mkDefault true;
        de.gnome.enable = mkDefault false;
        gui.enable = mkDefault false;
      };
      programs.home-manager.enable = mkDefault true;
      nix =
        {
          gc = {
            automatic = osConfig == null;
            frequency = "daily";
            options = "--delete-older-than=7d";
          };
          settings = shared.nix.settings;
        }
        // (lib.optionalAttrs (osConfig != null) {
          inherit (osConfig.nix) extraOptions;
        });
      systemd.user.startServices = "sd-switch";
    };
  }
