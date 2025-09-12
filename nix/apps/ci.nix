{
  inputs,
  systems,
  ...
}: {
  perSystem = {
    self',
    config,
    lib,
    system,
    ...
  }: let
    inherit systems;
    inherit (inputs) self;
    inherit (self'.legacyPackages) pkgs;
  in {
    apps.generate-ci-matrix = let
      getOutputInfo = mkDerivationPath: output:
        lib.mapAttrsToList
        (name: subject: {
          inherit name;
          derivation = lib.escapeShellArg (mkDerivationPath name);
          system = subject.system or subject.pkgs.system;
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
      ciInfoFile = lib.pipe ciInfo [
        builtins.toJSON
        (pkgs.writeText "ci-info")
      ];
      program =
        pkgs.writers.writeNuBin
        "cimatrix"
        # nu
        ''
          # Prints available outputs as JSON
          def main [
            --system: string = all  # Filter by system
            --output: string = all  # Only include the specified output
          ]: nothing -> string {
            open "${ciInfoFile}"
            | from json
            | if $system != all {
              transpose
              | where { get column1 | columns | 'system' in $in }
              | update column1 { where system == $system }
              | transpose --header-row --as-record
            } else $in
            | if $output != all {
              get --optional $output | default []
            } else $in
            | to json --raw
          }
        '';
    in {
      inherit program;
      meta.description = "Generates a GitHub Actions build matrix";
    };
  };
}
