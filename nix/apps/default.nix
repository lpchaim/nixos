args: let
  inherit ((import ../lib args).loaders) importNonDefault;
in {
  imports = importNonDefault ./. args;
}
