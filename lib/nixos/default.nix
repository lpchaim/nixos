{lib, ...}: let
  inherit (lib.snowfall) fs;
  inherit (lib.snowfall.system) create-system;
in {
  nixos = {
    getTraitModules = traits:
      map (mod: fs.get-file "modules/nixos/traits/${mod}.nix") traits;
    mkSystem = {
      system,
      modules ? [],
      specialArgs ? [],
      channelName ? "nixpkgs"
    }: let
      systemArgs = {
        inherit channelName modules;
        target = system;
        path = ./systems/minimal;
        name = "minimal";
        specialArgs = {
          stateVersion = lib.versions.majorMinor lib.version;
        };
        systems = {};
        homes = {};
      };
      systemData = create-system systemArgs;
    in systemData.builder {
      inherit system;
      inherit (systemArgs) modules specialArgs;
    };
  };
}
