{
  self',
  lib,
  pkgs,
  ...
}: let
  inherit (self'.legacyPackages.scripts) nu-parse-help;
in
  pkgs.writeNuScriptBin "nu-generate-manpage"
  # nu
  ''
    # Converts the output of nu --help to a crude manpage
    def main []: nothing -> any {
      let sections = $in
        | ${lib.getExe nu-parse-help}
        | from json
       let name = [$sections.name $sections.description]
        | filter { $in != "" }
        | str join " - "
      let flags = $sections.flags
        | each { $"\t($in.switches)\n\t\t($in.description)" }
        | str join "\n";

    $"($sections.name | str upcase)\(1)

    NAME
    \t($name)

    OPTIONS
    ($flags)
    "
    }
  ''
