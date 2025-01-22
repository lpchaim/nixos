{pkgs, ...}:
pkgs.writers.writeNuBin "lastdl"
# nu
''
  # Prints the last downloaded file
  def main [ ]: nothing -> path {
    ls ~/Downloads
    | where type == file
    | sort-by modified --reverse
    | last
    | get name
  }
''
