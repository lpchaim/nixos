{pkgs, ...}:
pkgs.writers.writeNuBin "lastdl"
# nu
''

  # Prints the last downloaded file
  def main [
    --short # Prints the filename instead of full path
    --quote # Prints the raw path with added quotes
  ]: nothing -> string {
    ls ~/Downloads
    | where type == file
    | sort-by modified
    | last
    | get name
    | if $short { path basename } else { $in }
    | if $quote { $'"($in)"' } else { $in }
  }
''
