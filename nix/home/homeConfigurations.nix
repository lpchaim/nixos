{
  inputs,
  self,
  ...
}: let
  inherit (self.lib.flake) parseHomeName;
  inherit (inputs.nixpkgs) lib;
  specialArgs = {
    inherit inputs self;
    osConfig = {};
  };
  homeRoot = ./.;
  mkHome = home: {
    system ? "x86_64-linux",
    pkgs ? self.legacyPackages.${system}.pkgs,
    user ? (parseHomeName home).user,
    osConfig ? {},
    extraModules ? [],
  }: let
    extraSpecialArgs =
      specialArgs
      // {
        inherit osConfig;
        inherit (pkgs.stdenv.hostPlatform) system;
      };
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs extraSpecialArgs;
      modules =
        [
          (homeRoot + /modules)
          (homeRoot + /configs/${user}.nix)
          (homeRoot + /configs/${home}.nix)
        ]
        |> builtins.filter builtins.pathExists
        |> lib.concat extraModules
        |> lib.unique;
    };
  mkStandaloneHome = home: args: let
    parsedName = parseHomeName home;
    standaloneModule = {
      home.username = parsedName.user;
      my = {
        hostName = parsedName.host or null;
        profiles.standalone = true;
      };
    };
    extraModules = (args.extraModules or []) ++ [standaloneModule];
  in
    mkHome home (args // {inherit extraModules;});
  mkNixosHomes = nixosConfigurations:
    nixosConfigurations
    |> lib.mapAttrsToList (
      hostName: {
        config,
        pkgs,
        ...
      }:
        config.home-manager.users
        |> lib.mapAttrsToList (userName: _:
          lib.nameValuePair
          "${userName}@${hostName}"
          (mkHome userName {
            inherit pkgs;
            osConfig = config;
          }))
    )
    |> lib.flatten
    |> lib.listToAttrs;
in {
  flake.homeConfigurations =
    mkNixosHomes self.nixosConfigurations
    // {
      "cheina@pc082" = mkStandaloneHome "cheina@pc082" {};
      "lpchaim@steamdeck" = mkStandaloneHome "lpchaim@steamdeck" {};
    };
}
