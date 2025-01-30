{inputs, ...}: let
  inherit (inputs.self.lib.loaders) listNonDefaultRecursive;
in {
  imports = listNonDefaultRecursive ./.;
}
