{pkgs, ...}:
pkgs.writeNuScriptStdinBin "nu-generate-carapace-spec"
# nu
''
  # Generates carapace completion spec based on structured command metadata
  def main []: string -> string {
    $in
    | from nuon
    | insert flags ($in.params
        | each { [
          ($in.name
            | parse --regex '^(?<full>--\w*)(?:\s*\((?<abbr>-\w*)\))?'
            | first
            | select abbr full | values
            | where { is-not-empty }
            | str join ', ')
          $in.description
        ] }
        | into record)
    | select name description flags
    | to yaml
  }
''
