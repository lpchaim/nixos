{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  version = 1;
  doc = ''
    The `systems` flake output defines the systems supported by this flake.
  '';
  inventory = output: let
    recurse = list: {
      children = lib.genAttrs list (attrName: {
        what = "supported system";
        evalChecks.supportedSystem = lib.systems.flakeExposed ? ${attrName};
      });
    };
  in
    recurse output;
}
