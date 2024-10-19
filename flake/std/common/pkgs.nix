{
  inputs,
  cell,
}: let
  overlays = inputs.cells.common.overlays.default;
in rec {
  default = unstable;
  cuda = import inputs.nixpkgs {
    inherit overlays;
    allowUnfree = true;
    cudaSupport = true;
  };
  deck = import inputs.nixpkgs {
    allowUnfree = true;
    overlays =
      overlays
      ++ [inputs.jovian.overlays.default];
  };
  stable = import inputs.stable {
    inherit overlays;
    allowUnfree = true;
  };
  unstable = import inputs.unstable {
    inherit overlays;
    allowUnfree = true;
  };
}
