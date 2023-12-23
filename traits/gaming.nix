{ pkgs, ... }:

{
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    package = pkgs.steam;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
