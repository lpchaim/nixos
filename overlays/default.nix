{inputs, ...}: let
  inherit (inputs) self;
in
  final: prev: {
    nix-conf = let
      homeCfg = self.legacyPackages.${prev.system}.homeConfigurations.minimal.config.home;
      nixCfg = homeCfg.file."${homeCfg.homeDirectory}/.config/nix/nix.conf".source;
    in
      nixCfg;
    # Temporary fix for xdg-desktop-portal-gnome
    # See https://github.com/NixOS/nixpkgs/pull/345979
    xdg-desktop-portal-gtk = prev.xdg-desktop-portal-gtk.overrideAttrs (old: {
      buildInputs = [
        prev.glib
        prev.gtk3
        prev.xdg-desktop-portal
        prev.gsettings-desktop-schemas # settings exposed by settings portal
        prev.gnome-desktop
        prev.gnome-settings-daemon # schemas needed for settings api (mostly useless now that fonts were moved to g-d-s, just mouse and xsettings)
      ];
      mesonFlags = [];
    });
  }
