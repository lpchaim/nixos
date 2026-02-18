{
  services.flatpak = {
    overrides.global.Environment = {
      XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
    };
    uninstallUnmanaged = false;
    update.auto.enable = true;
  };
}
