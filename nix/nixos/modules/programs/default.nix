{
  programs = {
    adb.enable = true;
    fish.enable = true;
    nix-ld.enable = true;
    nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep 5";
      };
    };
    zsh.enable = true;
  };
}
