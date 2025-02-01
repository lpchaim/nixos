# Slightly different nu writers with support from reading from stdin
{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in (final: prev: {
  writers =
    prev.writers
    // (let
      inherit (final.writers) makeScriptWriter;
      interpreter = "${lib.getExe final.nushell} --no-config-file --stdin";
    in rec {
      writeNuStdin = name: argsOrScript:
        if lib.isAttrs argsOrScript && !lib.isDerivation argsOrScript
        then makeScriptWriter (argsOrScript // {inherit interpreter;}) name
        else makeScriptWriter {inherit interpreter;} name argsOrScript;
      writeNuStdinBin = name: writeNuStdin "/bin/${name}";
    });
})
