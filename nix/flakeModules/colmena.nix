# Adapted from https://github.com/juspay/colmena-flake
{
  inputs,
  lib,
  self,
  withSystem,
  ...
}: {
  flake = withSystem "x86_64-linux" ({system, ...}: let
    nixosConfigurations =
      self.nixosConfigurations
      |> lib.filterAttrs (_: val: val.config.my.deploy.enable);
    hostConfigs =
      nixosConfigurations
      |> builtins.mapAttrs (name: value: {
        imports =
          value._module.args.modules
          ++ [
            ({config, ...}: {
              deployment = let
                defaultNames = builtins.attrNames colmenaConfig.defaults.deployment;
                namesToIgnore = defaultNames ++ ["enable"];
              in
                removeAttrs config.my.deploy namesToIgnore;
            })
          ];
      });
    colmenaConfig = {
      meta = {
        nixpkgs = self.lib.mkPkgs {inherit system;};
        nodeSpecialArgs =
          nixosConfigurations
          |> builtins.mapAttrs (_: value: value._module.specialArgs);
      };
      defaults.deployment = {
        allowLocalDeployment = true;
      };
    };
  in {
    colmenaHive = inputs.colmena.lib.makeHive (colmenaConfig // hostConfigs);
  });
}
