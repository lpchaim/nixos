args: let
  inherit ((import ../lib args).loaders) listNonDefault;
in {
  imports = listNonDefault ./.;
}
