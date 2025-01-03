{inputs, ...} @ args: let
  inherit (inputs.self.lib.loaders) loadNonDefault;
in
  loadNonDefault ./. args
