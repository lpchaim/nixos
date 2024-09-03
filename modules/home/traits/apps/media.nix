{pkgs, ...}: {
  programs = {
    mpv.enable = true;
  };
  home.packages = with pkgs; [
    jellyfin-media-player
    vlc
  ];
}
