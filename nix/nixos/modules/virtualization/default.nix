{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.virtualisation;
in {
  options.my.virtualisation.enable = lib.mkEnableOption "virtualisation tweaks";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      distrobox
    ];
    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = true;
      };
    };
  };
}
