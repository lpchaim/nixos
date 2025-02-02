{
  self',
  lib,
  pkgs,
  ...
}: let
  inherit (self'.legacyPackages.scripts) leastspaces;
in
  pkgs.writeNuScriptBin "nu-parse-help"
  # nu
  ''
    # Creates a record representation of a command's --help output
    def main [
      command?: string
    ]: nothing -> string {
      let sections = $in
        | split row --regex "\n\n"
        | each {
          parse --regex '^(?<header>[^:]+:)?\n?(?<contents>.*(?:\n.*)*)?'
          | update header { str replace --regex ':$' "" | str downcase }
          | update contents { ${lib.getExe leastspaces} }
        }
        | filter { $in.header != "" or $in.content != "" }
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
