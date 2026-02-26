{
  config,
  inputs,
  lib,
  ...
}: {
  options.my.deploy = let
    colmenaModule = inputs.colmena.nixosModules.deploymentOptions {
      inherit lib;
      name = config.networking.hostName;
    };
    deployOptions = colmenaModule.options.deployment;
  in
    deployOptions
    // {
      enable =
        lib.mkEnableOption "deployment"
        // {default = !config.my.deprecated;};
    };
}
