{inputs, ...}: let
  inherit (inputs) self;
  inherit (inputs.nixpkgs) lib;
in
  final: prev: {
    inherit
      (inputs.chaotic.packages.${prev.system}.jovian-chaotic)
      mesa-radeonsi-jupiter
      mesa-radv-jupiter
      ;
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
    proton-ge-bin-versions = let
      latestPackage = prev.proton-ge-bin;
      legacyVersions = {
        "7-55" = "sha256-6CL+9X4HBNoB/yUMIjA933XlSjE6eJC86RmwiJD6+Ws=";
        "8-32" = "sha256-ZBOF1N434pBQ+dJmzfJO9RdxRndxorxbJBZEIifp0w4=";
      };
      legacyPackages =
        lib.mapAttrs
        (_version: hash:
          latestPackage.overrideAttrs (_: rec {
            pname = "proton-ge-bin-${_version}";
            version = "GE-Proton${_version}";
            src = prev.fetchzip {
              url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
              inherit hash;
            };
          }))
        legacyVersions;
    in
      legacyPackages
      // {"latest" = latestPackage;};
  }
