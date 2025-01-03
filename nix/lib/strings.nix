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
}
