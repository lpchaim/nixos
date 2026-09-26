{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  cfg = config.my.gaming;
in {
  options.my.gaming.enable =
    lib.mkEnableOption "gaming tweaks"
    // {default = osConfig.my.gaming.enable or false;};

  config = lib.mkIf cfg.enable {
    services.flatpak.packages = [
      "com.fightcade.Fightcade"
    ];
  };
}
