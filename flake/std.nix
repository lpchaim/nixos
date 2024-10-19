{self, ...}: {inputs, ...}: let
  inherit (inputs) std;
in {
  std = {
    grow = {
      cellsFrom = self + /flake/std;
      cellBlocks = with std.blockTypes; [
        # Exposed blocks
        (installables "packages" {ci.build = true;})
        (devshells "shells" {ci.build = true;})

        # Internal blocks
        (functions "lib")
        (functions "modules")
        (functions "overlays")
        (pkgs "pkgs")
      ];
      nixpkgsConfig.allowUnfree = true;
    };
    harvest = {
      packages = [
        ["common" "packages"]
      ];
      devShells = [
        ["common" "shells"]
      ];
    };
  };
}
