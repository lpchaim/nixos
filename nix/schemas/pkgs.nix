{systems, ...}: {
  version = 1;
  doc = ''
    The `pkgs` flake output defines fixed nixpkgs instances.
  '';
  inventory = output: let
    recurse = attrs: {
      children = builtins.mapAttrs (attrName: attr:
        if builtins.isAttrs attr
        then {
          what = "nixpkgs instance";
          evalChecks.supportedSystem = builtins.elem attrName systems;
        }
        else throw "unsupported 'pkgs' system")
      attrs;
    };
  in
    recurse output;
}
