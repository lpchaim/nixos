{inputs, ...}: let
  inherit (inputs.self.lib) mkPkgs;
in (final: prev: {
  stable = mkPkgs {
    inherit (prev.stdenv.hostPlatform) system;
    nixpkgs = inputs.stable;
  };
  unstable = mkPkgs {
    inherit (prev.stdenv.hostPlatform) system;
    nixpkgs = inputs.unstable;
  };
})
