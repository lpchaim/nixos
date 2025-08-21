{
  self',
  lib,
  pkgs,
  ...
}: let
  inherit (self'.legacyPackages.scripts) nu-parse-help;
in
  pkgs.writeNuScriptBin "nu-generate-carapace-spec"
  # nu
  ''
    # Converts the output of nu --help to a carapace spec
    def main []: string -> string {
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
      | str replace --all --regex '\\e\[\d*m' "" # Don't even ask
    }
  ''
