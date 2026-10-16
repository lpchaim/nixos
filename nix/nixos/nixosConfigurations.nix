{inputs, ...}: let
  inherit (inputs) self;
  inherit (inputs.nixpkgs) lib;
  specialArgs = {
    inherit inputs self;
    osConfig = {};
  };
  homeRoot = ../home;
  osRoot = ./.;
  mkNixos = host: {
    system ? "x86_64-linux",
    users ? ["lpchaim"],
  }:
    lib.nixosSystem {
      inherit specialArgs system;
      modules = [
        (osRoot + /modules)
        (osRoot + /configs/${host})
        {
          networking.hostName = lib.mkDefault host;
          home-manager = {
            extraSpecialArgs = specialArgs // {osConfig = self.nixosConfigurations.${host}.config;};
            sharedModules = [(homeRoot + /modules)];
            users = lib.genAttrs users (user: homeRoot + /configs/${user}.nix);
          };
        }
      ];
    };
in {
  flake.nixosConfigurations = {
    desktop = mkNixos "desktop" {};
    laptop = mkNixos "laptop" {};
    raspberrypi = mkNixos "raspberrypi" {system = "aarch64-linux";};
    steamdeck = mkNixos "steamdeck" {};
  };
}
