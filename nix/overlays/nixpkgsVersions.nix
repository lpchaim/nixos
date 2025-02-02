{inputs, ...}: let
  inherit (inputs.self.lib) mkPkgs;
in (final: prev: {
  stable = mkPkgs {
    inherit (prev) system;
    nixpkgs = inputs.stable;
  };
  unstable = mkPkgs {
    inherit (prev) system;
    nixpkgs = inputs.unstable;
  };
})
