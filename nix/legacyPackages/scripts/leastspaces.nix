{writeNuScriptStdinBin, ...}:
writeNuScriptStdinBin "leastspaces"
# nu
''
  # Computes the least prepending spaces present in any line of the supplied text
  def main []: string -> any {
    let lines = $in
      | split row "\n";
    let least = $lines
      | each {
        parse --regex '^(\s*)'
        | values
        | first
        | str length
      }
      | math min
    $lines
      | each { str substring ($least | first).. }
      | str join "\n"
  }
''
