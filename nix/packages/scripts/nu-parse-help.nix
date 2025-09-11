{
  self',
  lib,
  pkgs,
  ...
}: let
  inherit (self'.legacyPackages.scripts) leastspaces;
in
  pkgs.writeNuScriptStdinBin "nu-parse-help"
  # nu
  ''
    # Creates a record representation of a command's --help output
    def main []: string -> any {
      let sections = $in
        | split row --regex "\n\n"
        | where { str trim | $in != "" }
        | each {
          parse --regex '^(?<header>[^:]+:)?\n?(?<contents>.*(?:\n.*)*)?'
          | update header { default "" | str replace --regex ':$' "" | str downcase }
          | update contents { ${lib.getExe leastspaces} }
        }
        | where { $in.header != "" or $in.content != "" }
        | flatten
      let description = $sections
        | where header == ""
        | first
        | safeget contents ""
      let usage = $sections
        | where header =~ usage
        | first
        | safeget contents ""
        | str substring 2..
      let name = $usage
        | parse --regex '(?<name>\w*) .*'
        | first
        | safeget name ""
      let flags = $sections
        | where header =~ flags
        | first
        | safeget contents ""
        | split row "\n"
        | each {
          split row ": "
          | {
            switches: $in.0
            description: $in.1
          }}

        {
          name: $name
          description: $description
          usage: $usage
          flags: $flags
        }
        | to json
    }

    def safeget [
      field: string
      default: string
    ]: record -> string {
      $in
      | get --ignore-errors $field
      | default $default
    }
  ''
