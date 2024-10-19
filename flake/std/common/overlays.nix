{
  inputs,
  cell,
}: rec {
  default = internal ++ external;
  internal = [
    (import (inputs.self + /overlays) {inherit inputs;})
  ];
  external = with inputs; [
    chaotic.overlays.default
    nh.overlays.default
    nix-gaming.overlays.default
    nix-software-center.overlays.pkgs
    nixneovimplugins.overlays.default
    snowfall-flake.overlays.default
  ];
}
