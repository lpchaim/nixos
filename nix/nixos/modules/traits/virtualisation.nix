{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib) isNvidia;
  cfg = config.my.traits.virtualisation;
in {
  options.my.traits.virtualisation.enable = lib.mkEnableOption "virtualisation trait";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      distrobox
    ];
    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = true;
        enableNvidia = isNvidia config;
      };
    };
  };
}
