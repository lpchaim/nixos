{inputs, ...}: final: prev: let
  inherit (inputs) self;
  inherit (prev.stdenv.hostPlatform) system;
in
  self.packages.${system} or {}
