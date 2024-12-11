{config, ...}: {
  environment.systemPackages = [
    config.programs.kdeconnect.package
  ];
  programs.kdeconnect.enable = true;
}
