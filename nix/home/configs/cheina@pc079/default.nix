{
  my.traits = {
    non-nixos.enable = true;
    work.enable = true;
  };

  home = rec {
    username = "cheina";
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
  };
}
