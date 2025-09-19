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
    lib.pipe path [
      (path:
        if recursive
        then
          (inputs.haumea.lib.load {
            src = path;
            loader = inputs.haumea.lib.loaders.path;
          })
        else
          (lib.pipe path [
            builtins.readDir
            (builtins.mapAttrs (name: type:
              if (type == "directory" && builtins.pathExists (path + /${name}/default.nix))
              then (path + /${name}/default.nix)
              else (path + /${name})))
            (lib.concatMapAttrs (name: path: {${lib.removeSuffix ".nix" name} = path;}))
          ]))
      (attr: builtins.removeAttrs attr ["default" "default.nix"])
      (lib.filterAttrsRecursive (_: path: filterFn path))
    ];

  # Lists files as paths
  list = {
    path,
    filterFn ? (x: true),
    recursive ? false,
  }:
    lib.pipe path [
      (path: read {inherit path recursive;})
      (lib.collect builtins.isPath)
      (builtins.filter (path: filterFn path))
      (builtins.map (path:
        lib.pipe path [
          builtins.toString
          (lib.removeSuffix "/default.nix")
          (x: /. + x)
        ]))
    ];

  # Lists files ending in default.nix
  listDefault = path:
    list {
      inherit path;
      filterFn = lib.hasSuffix "default.nix";
    };

  # Lists files ending in default.nix recursively
  listDefaultRecursive = path:
    list {
      inherit path;
      filterFn = lib.hasSuffix "default.nix";
      recursive = true;
    };

  # Lists files not ending in default.nix
  listNonDefault = path:
    list {
      inherit path;
      filterFn = path: ! (lib.hasSuffix "default.nix" path);
    };

  # Lists files not ending in default.nix
  listNonDefaultRecursive = path:
    list {
      inherit path;
      filterFn = path: ! (lib.hasSuffix "default.nix" path);
      recursive = true;
    };

  # Imports modules ending in default.nix
  importDefault = path: args:
    lib.pipe path [
      listDefault
      (builtins.map (path: import path args))
    ];

  # Imports modules not ending in default.nix
  importNonDefault = path: args:
    lib.pipe path [
      listNonDefault
      (builtins.map (path: import path args))
    ];

  # Loads modules while preserving directory structure
  load = {
    path,
    args,
    filterFn ? (x: true),
    loader ? inputs.haumea.lib.loaders.default,
  }:
    lib.pipe path [
      (path:
        inputs.haumea.lib.load {
          inherit loader;
          src = path;
          inputs = args;
        })
      (attr: builtins.removeAttrs attr ["default"])
    ];

  # Loads files ending in default.nix while preserving directory structure
  loadDefault = path: args:
    load {
      inherit args path;
      filterFn = lib.hasSuffix "default.nix";
    };

  # Loads files not ending in default.nix while preserving directory structure
  loadNonDefault = path: args:
    load {
      inherit args path;
      filterFn = path: ! (lib.hasSuffix "default.nix" path);
    };

  # Runs callPackage on files ending in default.nix, always recursive
  callPackageDefault = path: pkgs:
    lib.pipe path [
      (path:
        read {
          inherit path;
          filterFn = lib.hasSuffix "default.nix";
        })
      (builtins.mapAttrs (_: path:
          lib.callPackageWith (builtins.removeAttrs pkgs ["root"]) path {}))
    ];

  # Runs callPackage on files not ending in default.nix, always recursive
  callPackageNonDefault = path: pkgs:
    lib.pipe path [
      (path:
        read {
          inherit path;
          filterFn = path: ! (lib.hasSuffix "default.nix" path);
        })
      (builtins.mapAttrs (_: path:
          lib.callPackageWith (builtins.removeAttrs pkgs ["root"]) path {}))
    ];
}
