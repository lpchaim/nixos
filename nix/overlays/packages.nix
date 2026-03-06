{inputs, ...}: final: prev: let
  inherit (prev.stdenv.hostPlatform) system;
in
  inputs.self.packages.${system} or {}
