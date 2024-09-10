{lib, ...}: let
  inherit (lib.snowfall) home fs;
  inherit (lib.lpchaim.shared) defaults;
in {
  home = {
    getTraitModules = traits:
      map (mod: fs.get-file "modules/home/traits/${mod}.nix") traits;
    mkHome = {
      system,
      modules ? [],
      specialArgs ? {},
      channelName ? "nixpkgs"
    }: let
      homeArgs = {
        inherit channelName modules system;
        name = "minimal";
        path = ../../homes/minimal;
        specialArgs =
          rec {
            username = defaults.name.user;
            homeDirectory = "/home/${username}";
            stateVersion = lib.versions.majorMinor lib.version;
          }
          // specialArgs;
      };
      homeData = home.create-home homeArgs;
    in
      homeData.builder {
        inherit (homeData) modules specialArgs system;
      };
  };
}
