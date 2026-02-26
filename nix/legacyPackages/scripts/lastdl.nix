{
  writeNuScriptStdinBin,
  xdg-user-dirs,
  ...
}:
writeNuScriptStdinBin "lastdl"
# nu
''
  # Print the last downloaded file
  def main [
    --short # Print the filename instead of full path
    --quote # Print the raw path with added quotes
  ]: nothing -> string {
    ls (${xdg-user-dirs}/bin/xdg-user-dir DOWNLOAD)
    | where type == file
    | sort-by modified
    | last
    | get name
    | if $short { path basename } else { $in }
    | if $quote { $'"($in)"' } else { $in }
  }
''
