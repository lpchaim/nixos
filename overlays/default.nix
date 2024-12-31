{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in
  final: prev: {
    inherit
      (inputs.chaotic.packages.${prev.system}.jovian-chaotic)
      mesa-radeonsi-jupiter
      mesa-radv-jupiter
      ;
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
