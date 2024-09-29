{
  inputs,
  lib,
  ...
}: {
  nix = inputs.nixpkgs.lib;
  std = inputs.nix-std.lib;
  mkModule = {
    namespace,
    config,
    description ? "module",
    options ? {},
    configBuilder ? cfg: {},
    namespacedConfigBuilder ? cfg: {},
    imports ? [],
  }: let
    ns = lib.splitString "." namespace;
    cfg = lib.getAttrFromPath ns config;
  in {
    inherit imports;
    options = let
      finalOptions = {enable = lib.mkEnableOption description;} // options;
    in
      lib.setAttrByPath ns finalOptions;
    config = let
      rootConfig = configBuilder cfg;
      namespacedConfig = namespacedConfigBuilder cfg;
    in
      lib.mkMerge [
        (
          if rootConfig != {}
          then rootConfig
          else {}
        )
        (
          if namespacedConfig != {}
          then (lib.setAttrByPath ns namespacedConfig)
          else {}
        )
      ];
  };
  mkEnableOptionWithDefault = description: default:
    (lib.mkEnableOption description) // {inherit default;};
}
