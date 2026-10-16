{inputs, ...}: let
  inherit (inputs.self.lib) importDir;
in {
  flake.homeModules =
    (importDir ./modules)
    // (importDir ../shared);
}
