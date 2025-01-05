{inputs, ...}: let
  inherit (inputs.self.lib.loaders) listNonDefault;
in {
  imports = listNonDefault ./.;
}
