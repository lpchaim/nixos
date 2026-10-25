{inputs, ...}: let
  inherit (inputs) self;
  inherit (inputs.nixpkgs) lib;
  specialArgs = {
    inherit inputs self;
    osConfig = {};
  };
  homeRoot = ./.;
  mkHome = home: {
    system ? "x86_64-linux",
    pkgs ? self.legacyPackages.${system}.pkgs,
    osConfig ? {},
    extraModules ? [],
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = specialArgs // {inherit osConfig;};
      modules =
        [
          (homeRoot + /modules)
          (homeRoot + /configs/lpchaim.nix)
          (homeRoot + /configs/${home}.nix)
        ]
        ++ extraModules;
    };
  mkStandaloneHome = home: args:
    mkHome home (args
      // {
        extraModules = [
          {
            home.username = lib.splitString "@" home |> lib.head;
            my = {
              hostName = lib.splitString "@" home |> lib.last;
              profiles.standalone = true;
            };
          }
        ];
      });
in {
  flake.homeConfigurations =
    {
      "cheina@pc082" = mkStandaloneHome "cheina@pc082" {};
      "lpchaim@steamdeck" = mkStandaloneHome "lpchaim@steamdeck" {};
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
