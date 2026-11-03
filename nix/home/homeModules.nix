{inputs, ...}: {
  flake.homeModules = {
    bars = ./modules/bars;
    ci = ./modules/ci;
    cli = ./modules/cli;
    de = ./modules/de;
    development = ./modules/development;
    flatpak = ../common/flatpak.nix;
    gaming = ./modules/gaming;
    gui = ./modules/gui;
    llm = ./modules/llm;
    misc = ./modules/misc;
    nix = ./modules/nix;
    profiles = ./profiles;
    scripts = ./modules/scripts;
    secrets = ./modules/secrets;
    security = ./modules/security;
    ssh = ./modules/ssh;
    syncthing = ./modules/syncthing;
    theming = ./modules/theming;
    wayland = ./modules/wayland;
    external.imports = with inputs; [
      agenix.homeManagerModules.default
      agenix-rekey.homeManagerModules.default
      dms.homeModules.dank-material-shell
      nix-index-database.homeModules.nix-index
      nix-flatpak.homeManagerModules.nix-flatpak
      nixvim.homeModules.nixvim
      spicetify-nix.homeManagerModules.default
      stylix.homeModules.stylix
      wayland-pipewire-idle-inhibit.homeModules.default
    ];
  };
}
