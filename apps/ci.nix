{
  self,
  inputs,
  mkPkgs,
  ...
}: {
  perSystem = {
    config,
    lib,
    system,
    ...
  }: let
    pkgs = mkPkgs system;
    systems = import inputs.systems;
  in {
    apps = let
      getOutputInfo = mkDerivationPath: output:
        lib.mapAttrsToList
        (name: subject: {
          inherit name;
          derivation = mkDerivationPath name;
          system = subject.system or subject.pkgs.system;
        })
        output;
      getNestedOutputInfo = mkDerivationPath: output:
        lib.concatMap (system: getOutputInfo (mkDerivationPath system) output.${system})
        systems;
      ciInfo = {
        homeConfigurations =
          getOutputInfo
          (name: ''.#homeConfigurations."${name}".activationPackage'')
          self.homeConfigurations;
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
    in {
      get-ci-info.program =
        pkgs.writeNushellScriptBin
        "get-ci-info"
        # nu
        ''
          # Prints available outputs as JSON
          def main [
            --system: string = all  # Filter by system
          ]: nothing -> string {
            open "${ciInfoFile}"
            | from json
            | if $system != all {
                transpose
                | filter { get column1 | columns | 'system' in $in }
                | update column1 { where system == $system }
                | transpose --header-row --as-record
            } else $in
            | to json
          }
        '';
    };
  };
}