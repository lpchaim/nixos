{
  inputs,
  lib,
  ...
}: rec {
  # Lists files as paths
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

  # Lists files not ending in default.nix
  listNonDefault = path:
    list {
      inherit path;
      filterFn = path: ! (lib.hasSuffix "default.nix" path);
    };

  # Loads modules while preserving directory structure
  load = {
    path,
    args,
    filterFn ? (x: true),
  }:
    lib.pipe path [
      (path:
        inputs.haumea.lib.load {
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
}
