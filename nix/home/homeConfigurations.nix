{inputs, ...}: let
  inherit (inputs) self;
  inherit (inputs.nixpkgs) lib;
  specialArgs = {
    inherit inputs self;
    osConfig = {};
  };
  homeRoot = ./.;
  mkHome = user: {
    system ? "x86_64-linux",
    pkgs ? self.legacyPackages.${system}.pkgs,
    osConfig ? {},
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = specialArgs // {inherit osConfig;};
      modules = [
        (homeRoot + /modules)
        (homeRoot + "/configs/${user}.nix")
      ];
    };
in {
  flake.homeConfigurations =
    {
      "cheina@pc082" = mkHome "cheina@pc082" {};
    }
    // lib.concatMapAttrs (
      osName: {
        config,
        pkgs,
        ...
      }:
        lib.concatMapAttrs (userName: home: {
          "${userName}@${osName}" = mkHome userName {
            inherit pkgs;
            inherit (pkgs.stdenv.hostPlatform) system;
            osConfig = config;
          };
        })
        config.home-manager.users
    )
    self.nixosConfigurations;
}
