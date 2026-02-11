{
  inputs,
  systems,
  ...
}: let
  inherit (inputs) self;
in {
  perSystem = {
    lib,
    pkgs,
    ...
  }: let
    getOutputInfo = mkDerivationPath: output:
      lib.mapAttrsToList
      (name: drv: {
        inherit name;
        derivation = lib.escapeShellArg (mkDerivationPath name);
        system = drv.system or drv.pkgs.stdenv.hostPlatform.system;
      })
      output;
    getPerSystemOutputInfo = mkDerivationPath: output:
      lib.concatMap (system: getOutputInfo (mkDerivationPath system) output.${system})
      systems;
    filterToBuild = lib.filterAttrs (_: drv: drv.config.my.ci.build or false);
    filterPerSystemToBuild = lib.filterAttrsRecursive (
      name: drv:
        !(lib.isDerivation drv)
        || (
          (name != "default")
          && (drv.passthru.my.ci.${drv.system}.build or drv.passthru.my.ci.build or false) == true
        )
    );
    ciInfo = {
      homeConfigurations =
        self.homeConfigurations
        |> (lib.filterAttrs (_: home: home._module.specialArgs.osConfig == {})) # Standalone only
        |> filterToBuild
        |> (getOutputInfo (name: ''.#homeConfigurations."${name}".activationPackage''));
      nixosConfigurations =
        self.nixosConfigurations
        |> filterToBuild
        |> (getOutputInfo (name: ''.#nixosConfigurations."${name}".config.system.build.toplevel''));
      packages =
        self.packages
        |> filterPerSystemToBuild
        |> (getPerSystemOutputInfo (system: name: ''.#packages.${system}."${name}"''));
      devShells =
        self.devShells
        |> filterPerSystemToBuild
        |> (getPerSystemOutputInfo (system: name: ''.#devShells.${system}."${name}"''));
    };
  in {
    legacyPackages.ciMatrix =
      pkgs.writeText
      "ci-matrix"
      (builtins.toJSON ciInfo);
  };
}
