{
  my.profiles = {
    standalone = true;
    work = true;
  };

  home = rec {
    username = "cheina";
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
  };

  programs.atuin.daemon.enable = false;
}
