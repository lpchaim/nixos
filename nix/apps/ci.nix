{...}: {
  perSystem = {
    self',
    config,
    lib,
    system,
    ...
  }: let
    inherit (self'.legacyPackages) pkgs;
  in {
    apps.generate-ci-matrix = {
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
            open "${self'.legacyPackages.ciMatrix}"
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
      meta.description = "Generates a GitHub Actions build matrix";
    };
  };
}
