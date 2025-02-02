# Provides new nu script writers with a few QoL enhancements
# - Support from reading from stdin
# - Extra newline prepended to content so script help contents display properly
{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in (final: prev: let
  inherit (prev.writers) makeScriptWriter;
  interpreter = "${lib.getExe prev.nushell} --no-config-file --stdin";
  patch = writer:
    writer.overrideAttrs (prev: {
      content = "\n${prev.content}";
    });
in rec {
  # Based on the original implementation, see https://noogle.dev/f/pkgs/writers/writeNu
  writeNuScript = name: argsOrScript:
    if lib.isAttrs argsOrScript && !lib.isDerivation argsOrScript
    then patch (makeScriptWriter (argsOrScript // {inherit interpreter;}) name)
    else patch (makeScriptWriter {inherit interpreter;} name argsOrScript);
  writeNuScriptBin = name: writeNuScript "/bin/${name}";
})
