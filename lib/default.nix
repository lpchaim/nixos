{ inputs, lib, ... }:

{
  nix = inputs.nixpkgs.lib;
  std = inputs.nix-std.lib;
  mkModule =
    { namespace
    , config
    , description ? "module"
    , options ? { }
    , rootConfig ? cfg: { }
    , moduleConfig ? cfg: { }
    }:
    let
      ns = lib.splitString "." namespace;
      cfg = lib.getAttrFromPath ns config;
    in
    {
      options =
        let finalOptions = { enable = lib.mkEnableOption description; } // options;
        in lib.setAttrByPath ns finalOptions;
      config =
        let
          finalRootConfig = rootConfig cfg;
          finalModuleConfig = moduleConfig cfg;
        in
        lib.mkIf (cfg.enable && (finalRootConfig != { } || finalModuleConfig != { }))
          (lib.mkMerge [ finalRootConfig finalModuleConfig ]);
    };
  mkEnableOptionWithDefault = description: default:
    (lib.mkEnableOption description) // { inherit default; };
}
