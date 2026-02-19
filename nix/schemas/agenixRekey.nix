{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  version = 1;
  doc = ''
    The `agenix-rekey` flake output defines executables used by agenix-rekey
  '';
  inventory = output: let
    recurse = attrs: {
      children = builtins.mapAttrs (attrName: attr:
        if lib.isDerivation attr
        then {
          what = "agenix-rekey executable";
        }
        else recurse attr)
      attrs;
    };
  in
    recurse output;
}
