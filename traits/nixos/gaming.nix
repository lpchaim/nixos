{ pkgs, ... }:

{
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    protontricks
  ];
}
