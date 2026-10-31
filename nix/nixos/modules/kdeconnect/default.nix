{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    config.programs.kdeconnect.package
  ];
  programs.kdeconnect = {
    enable = true;
    package = lib.mkDefault pkgs.kdePackages.kdeconnect-kde;
  };
}
