{
  inputs,
  systems,
  ...
}: let
  inherit (inputs) self;
in {
  perSystem = {
    config,
    inputs',
    lib,
    system,
    pkgs,
    ...
  }: let
    getOutputInfo = mkDerivationPath: output:
      lib.mapAttrsToList
      (name: subject: {
        inherit name;
        derivation = lib.escapeShellArg (mkDerivationPath name);
        system = subject.system or subject.pkgs.stdenv.hostPlatform.system;
      })
      output;
    getNestedOutputInfo = mkDerivationPath: output:
      lib.concatMap (system: getOutputInfo (mkDerivationPath system) output.${system})
      systems;
    ciInfo = let
      standaloneHomeConfigurations =
        lib.filterAttrs
        (name: _: let
          parts = lib.splitString "@" name;
          host = lib.last parts;
        in
          !(self.nixosConfigurations ? ${host}))
        self.homeConfigurations;
    in {
      homeConfigurations =
        getOutputInfo
        (name: ''.#homeConfigurations."${name}".activationPackage'')
        standaloneHomeConfigurations;
      nixosConfigurations =
        getOutputInfo
        (name: ''.#nixosConfigurations."${name}".config.system.build.toplevel'')
        self.nixosConfigurations;
      packages =
        getNestedOutputInfo
        (_: name: ''.#"${name}"'')
        self.packages;
      devShells =
        getNestedOutputInfo
        (system: name: ''.#devShells.${system}."${name}"'')
        self.devShells;
    };
  in {
    legacyPackages.ciMatrix =
      pkgs.writeText
      "ci-matrix"
      (builtins.toJSON ciInfo);
  };
}
