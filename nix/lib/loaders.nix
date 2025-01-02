{
  inputs,
  lib,
  ...
}: let
  list = {
    path,
    filterFn ? (x: true),
  }:
    lib.pipe path [
      (path:
        inputs.haumea.lib.load {
          src = path;
          loader = inputs.haumea.lib.loaders.path;
        })
      (attr: builtins.removeAttrs attr ["default"])
      (lib.collect builtins.isPath)
      (builtins.filter filterFn)
      (builtins.map (path:
        lib.pipe path [
          builtins.toString
          (lib.removeSuffix "/default.nix")
          (x: /. + x)
        ]))
    ];
in {
  listDefault = path:
    list {
      inherit path;
      filterFn = lib.hasSuffix "default.nix";
    };
  listNonDefault = path:
    list {
      inherit path;
      filterFn = ! (lib.hasSuffix "default.nix");
    };
}
