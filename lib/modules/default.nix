{
  inputs,
  lib,
  ...
}: let
  inherit (inputs.haumea.lib) load loaders;
  loadModules = src: match: let
    files = load {
      inherit src;
      loader = loaders.path;
    };
    modules = lib.pipe files [
      (lib.collect (it: (builtins.isString it) || (builtins.isPath it)))
      (map builtins.toString)
      (builtins.filter (v: lib.match match v != null))
      (map import)
    ];
  in
    modules;
in {
  modules = {
    loadModulesAll = src: loadModules src "^.*$";
    loadModulesDefault = src: loadModules src "^.*/default\.nix$";
  };
}
