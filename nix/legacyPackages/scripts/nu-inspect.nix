{
  lib,
  nushell,
  writeNuScriptStdinBin,
  ...
}:
writeNuScriptStdinBin "nu-inspect"
# nu
''
  # Outputs structured command data based on nushell script contents
  def main [
    --name: string = "main"
  ]: string -> string {
    $in | save ./tmp.nu
    ${lib.getExe nushell} --commands $"
      source './tmp.nu'

      help commands
      | where name == 'main'
      | to nuon
    "
    | from nuon
    | update name $name
    | first
    | to nuon
  }
''
