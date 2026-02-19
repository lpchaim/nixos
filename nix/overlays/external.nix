{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in
  lib.composeManyExtensions [
    inputs.agenix-rekey.overlays.default
    inputs.nix-gaming.overlays.default
  ]
