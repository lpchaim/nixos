{
  inputs,
  lib,
  ...
}: rec {
  # Reads files similarly to builtins.readDir
  read = {
    path,
    filterFn ? (x: true),
    recursive ? false,
  }:
    path
    |> (path:
      if recursive
      then
        (inputs.haumea.lib.load {
          src = path;
          loader = inputs.haumea.lib.loaders.path;
        })
      else
        (
          path
          |> builtins.readDir
          |> builtins.mapAttrs (name: type:
            if (type == "directory" && builtins.pathExists (path + /${name}/default.nix))
            then (path + /${name}/default.nix)
            else (path + /${name}))
          |> lib.concatMapAttrs (name: path: {${lib.removeSuffix ".nix" name} = path;})
        ))
    |> (attr: removeAttrs attr ["default" "default.nix"])
    |> lib.filterAttrsRecursive (_: path: filterFn path);

  # Loads modules while preserving directory structure
  load = {
    path,
    args,
    filterFn ? (x: true),
  }:
    read {
      inherit path filterFn;
      recursive = true;
    }
    |> lib.mapAttrsRecursiveCond
    builtins.isAttrs
    (_: x: let
      mod = import x;
    in
      if builtins.isAttrs mod
      then mod
      else mod args)
    |> (attr: removeAttrs attr ["default"]);

  # Loads files ending in default.nix while preserving directory structure
  loadDefault = path: args:
    load {
      inherit path args;
      filterFn = lib.hasSuffix "default.nix";
    };

  # Loads files not ending in default.nix while preserving directory structure
  loadNonDefault = path: args:
    load {
      inherit path args;
      filterFn = path: ! (lib.hasSuffix "default.nix" path);
    };
}
