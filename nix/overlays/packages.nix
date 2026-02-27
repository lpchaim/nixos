{self, ...}: final: prev: let
  inherit (prev.stdenv.hostPlatform) system;
in
  self.packages.${system} or {}
