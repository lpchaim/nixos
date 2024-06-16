{ inputs, lib, ... }:

{
  std = inputs.nix-std.lib;
  mkEnableOptionWithDefault = description: default:
    (lib.mkEnableOption description) // { inherit default; };
}
