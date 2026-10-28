{inputs, ...}: let
  inherit (inputs.self.lib) importDir;
in {
  flake.nixosModules =
    (importDir ./modules)
    // (importDir ../shared);
}
