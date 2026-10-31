{lib, ...}: let
  inherit
    (lib)
    attrNames
    attrValues
    replaceStrings
    ;
in {
  replaceUsing = replacements: str:
    replaceStrings
    (attrNames replacements)
    (attrValues replacements)
    str;
  stripEnclosing = lhs: rhs: str: str |> lib.removePrefix lhs |> lib.removeSuffix rhs;
}
