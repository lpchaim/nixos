{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in (final: prev: {
  proton-ge-bin-versions = let
    versions = {
      "7-55" = "sha256-6CL+9X4HBNoB/yUMIjA933XlSjE6eJC86RmwiJD6+Ws=";
      "8-32" = "sha256-ZBOF1N434pBQ+dJmzfJO9RdxRndxorxbJBZEIifp0w4=";
    };
    packages =
      lib.mapAttrs
      (version: hash:
        prev.proton-ge-bin.overrideAttrs (_: {
          pname = "proton-ge-bin-${version}";
          version = "GE-Proton${version}";
          src = prev.fetchzip {
            inherit hash;
            url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
          };
        }))
      versions;
  in
    packages;
})
