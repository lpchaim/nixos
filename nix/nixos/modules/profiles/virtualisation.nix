{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib) isNvidia;
  cfg = config.my.profiles.virtualisation;
in {
  options.my.profiles.virtualisation = lib.mkEnableOption "virtualisation profile";
  config = lib.mkIf cfg {
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
