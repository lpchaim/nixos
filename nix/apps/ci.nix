{
  self,
  systems,
  ...
}: {
  perSystem = {
    config,
    lib,
    system,
    ...
  }: let
    inherit systems;
    pkgs = self.pkgs.${system};
  in {
    apps.get-ci-info.program = let
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
    in
      pkgs.writers.writeNuBin
      "get-ci-info"
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
            | filter { get column1 | columns | 'system' in $in }
            | update column1 { where system == $system }
            | transpose --header-row --as-record
          } else $in
          | if $output != all {
            get --ignore-errors $output | default []
          } else $in
          | to json --raw
        }
      '';
  };
}
