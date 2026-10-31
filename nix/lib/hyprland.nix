{
  lib,
  self,
  ...
}: let
  stripParentheses = self.lib.strings.stripEnclosing "(" ")";
in {
  lua = rec {
    args = args: {_args = args;};
    bind = keys: dispatcher: flags:
      args [keys dispatcher flags];
    bindWithFlags = flags: keys: dispatcher:
      bind keys dispatcher flags;
    bindl = bindWithFlags {
      locked = true;
    };
    bindle = bindWithFlags {
      locked = true;
      repeating = true;
    };
    bindr = bindWithFlags {release = true;};
    exec = dispatcher: args:
      lua ''${dispatcher}(${args |> map (lib.generators.toLua {multiline = false;}) |> lib.concatStringsSep ", "})'';
    execCmd = cmd: exec "hl.dsp.exec_cmd" [cmd];
    local = var: {_var = var;};
    mod = keys: lua "mod .. ' + ${keys}'";
    on = event: execs:
      if (builtins.length execs > 0)
      then
        args [
          event
          (lua ''
            function()
              ${execs
              |> map (_exec: _exec |> lib.generators.toLua {} |> stripParentheses)
              |> lib.concatStringsSep "\n  "}
            end'')
        ]
      else args [];
    lua = lib.generators.mkLuaInline;
  };
}
