{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  version = 1;
  doc = ''
    The `lib` flake output defines Nix functions, namespaces and configuration constants.
  '';
  inventory = output: let
    recurse = attrs: {
      children = builtins.mapAttrs (attrName: attr:
        if builtins.isAttrs attr
        then {
          what = "library namespace";
        }
        else if builtins.isFunction attr
        then {
          what = "library function";
          evalChecks.camelCase = (lib.strings.toCamelCase attrName) == attrName;
        }
        else {
          what = "configuration constant";
          evalChecks.camelCase = (lib.strings.toCamelCase attrName) == attrName;
        })
      attrs;
    };
  in
    recurse output;
}
