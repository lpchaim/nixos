{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    android-tools
  ];
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    fish.enable = true;
    nix-ld.enable = true;
    nh = {
      enable = lib.mkDefault true;
      clean = {
        enable = config.programs.nh.enable;
        dates = "weekly";
        extraArgs = "--keep 5";
      };
    };
    zsh.enable = true;
  };
}
