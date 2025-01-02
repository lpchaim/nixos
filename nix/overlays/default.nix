{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in [
  (final: prev: {
    proton-ge-bin-versions = let
      latestPackage = prev.proton-ge-bin;
      legacyVersions = {
        "7-55" = "sha256-6CL+9X4HBNoB/yUMIjA933XlSjE6eJC86RmwiJD6+Ws=";
        "8-32" = "sha256-ZBOF1N434pBQ+dJmzfJO9RdxRndxorxbJBZEIifp0w4=";
      };
      legacyPackages =
        lib.mapAttrs
        (version: hash:
          latestPackage.overrideAttrs (_: {
            pname = "proton-ge-bin-${version}";
            version = "GE-Proton${version}";
            src = prev.fetchzip {
              inherit hash;
              url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
            };
          }))
        legacyVersions;
    in
      legacyPackages
      // {"latest" = latestPackage;};
  })
  inputs.chaotic.overlays.default
  inputs.nh.overlays.default
  inputs.nix-gaming.overlays.default
  inputs.nix-software-center.overlays.pkgs
  inputs.nixneovimplugins.overlays.default
]
