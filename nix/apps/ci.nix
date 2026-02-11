{...}: {
  perSystem = {self', ...}: let
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
            --branch: string  # Only include the specified branch
            --flatten  # Output a single list
          ]: nothing -> string {
            open "${self'.legacyPackages.ciMatrix}"
            | from json
            | if $system != all {
                filter-records { where system == $system }
              } else $in
            | if $branch != null {
                filter-records { where branch == $branch }
              } else $in
            | if $output != all {
                get --optional $output | default []
              } else $in
            | if $flatten {
                items { |output, $cols|
                  $cols
                  | insert output $output
                }
                | flatten
              } else $in
            | to json --raw
          }

          def filter-records [where]: record -> record {
              transpose
              | update column1 $where
              | transpose --header-row --as-record
          }
        '';
      meta.description = "Generates a GitHub Actions build matrix";
    };
  };
}
