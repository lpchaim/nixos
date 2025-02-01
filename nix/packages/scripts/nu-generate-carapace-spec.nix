{
  self',
  lib,
  pkgs,
  ...
}: let
  inherit (self'.legacyPackages.scripts) nu-parse-help;
in
  pkgs.writers.writeNuStdinBin "nu-generate-carapace-spec"
  # nu
  ''

    # Converts the output of nu --help to a carapace spec
    def main []: nothing -> any {
      let sections = $in
        | ${lib.getExe nu-parse-help}
        | from json

      {
        name: $sections.name
        description: $sections.description
        flags: ($sections.flags
          | each { [
            $in.switches
            $in.description
          ] }
          | into record)
      }
      | to yaml
      | rm-yaml-control-chars
    }

    # Don't ask
    def "rm-yaml-control-chars" []: string -> string {
      $in
      | str replace --all --regex '\\e\[\d*m' "" # Don't ask
    }
  ''
