{lib, ...}: {
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
      args [
        event
        (lua ''
          function()
            ${execs |> map (lib.generators.toLua {}) |> lib.concatStringsSep "\n  "}
          end
        '')
      ];
    lua = lib.generators.mkLuaInline;
  };
}
