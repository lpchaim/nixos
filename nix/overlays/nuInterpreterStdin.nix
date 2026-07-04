# Provides new nu script writers with a few QoL enhancements
# - Support from reading from stdin
# - Extra newline prepended to content so script help contents display properly
{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in (final: prev: let
  inherit (prev) coreutils nushell;
  inherit (prev.writers) makeScriptWriter;
  interpreter = "${coreutils}/bin/env -S ${lib.getExe nushell} --no-config-file --stdin";
  patch = writer:
    writer.overrideAttrs (prev: {
      content = "\n${prev.content}";
    });
in {
  # Based on the original implementation, see https://noogle.dev/f/pkgs/writers/writeNu
  writers =
    prev.writers
    // rec {
      writeNuStdin = name: argsOrScript:
        if lib.isAttrs argsOrScript && !lib.isDerivation argsOrScript
        then patch (makeScriptWriter (argsOrScript // {inherit interpreter;}) name)
        else patch (makeScriptWriter {inherit interpreter;} name argsOrScript);
      writeNuBinStdin = name: writeNuStdin "/bin/${name}";
    };
})
