{inputs, ...}: let
  inherit (inputs) self;
  inherit (self) systems;
in {
  perSystem = {
    lib,
    pkgs,
    ...
  }: let
    getOutputInfo = mkDerivationPath: output:
      lib.mapAttrsToList (name: drv: {
        inherit name;
        derivation =
          name
          |> lib.strings.escapeNixIdentifier
          |> mkDerivationPath
          |> lib.escapeShellArg;
        system = drv.system or drv.pkgs.stdenv.hostPlatform.system;
        branch = drv.config.my.ci.branches or [];
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
          && (
            ((drv.passthru.my.ci.build or false) == true)
            || (builtins.elem drv.system (drv.passthru.my.ci.buildFor or []))
          )
        )
    );
    spreadBranchOrDefault = defaultBranches: infos:
      lib.concatMap
      (info: (lib.concatMap
        (branch: [(info // {inherit branch;})])
        (
          if (builtins.length info.branch > 0)
          then info.branch
          else defaultBranches
        )))
      infos;
    ciInfo = {
      homeConfigurations =
        self.homeConfigurations
        |> lib.filterAttrs (_: home: home._module.specialArgs.osConfig == {}) # Standalone only
        |> filterToBuild
        |> getOutputInfo (name: ".#homeConfigurations.${name}.activationPackage")
        |> spreadBranchOrDefault [];
      nixosConfigurations =
        self.nixosConfigurations
        |> filterToBuild
        |> getOutputInfo (name: ".#nixosConfigurations.${name}.config.system.build.toplevel")
        |> spreadBranchOrDefault [];
      packages =
        self.packages
        |> filterPerSystemToBuild
        |> getPerSystemOutputInfo (system: name: ".#packages.${system}.${name}")
        |> spreadBranchOrDefault ["main" "develop"];
      devShells =
        self.devShells
        |> filterPerSystemToBuild
        |> getPerSystemOutputInfo (system: name: ".#devShells.${system}.${name}")
        |> spreadBranchOrDefault ["main" "develop"];
    };
  in {
    legacyPackages.ciMatrix =
      ciInfo
      |> builtins.toJSON
      |> pkgs.writeText "ci-matrix";
  };
}
