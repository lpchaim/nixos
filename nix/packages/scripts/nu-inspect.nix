{
  lib,
  pkgs,
  ...
}:
pkgs.writeNuScriptStdinBin "nu-inspect"
# nu
''
  # Outputs structured command data based on nushell script at given path
  def main [
    --name: string = "main"
  ]: string -> string {
    ${lib.getExe pkgs.nushell} --commands $"
      source '($in)'

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
