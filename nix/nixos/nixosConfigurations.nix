{
  inputs,
  self,
  ...
}: let
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
    extraModules ? [],
  }:
    lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs // {inherit system;};
      modules =
        [
          (osRoot + /modules)
          (osRoot + /configs/${host})
          ({config, ...}: {
            networking.hostName = lib.mkDefault host;
            home-manager = {
              extraSpecialArgs = specialArgs // {osConfig = config;};
              sharedModules = [(homeRoot + /modules)];
              users = lib.genAttrs users (user: homeRoot + /configs/${user}.nix);
            };
          })
        ]
        ++ extraModules;
    };
in {
  flake.nixosConfigurations = {
    desktop = mkNixos "desktop" {};
    laptop = mkNixos "laptop" {};
    raspberrypi = mkNixos "raspberrypi" {system = "aarch64-linux";};
  };
}
