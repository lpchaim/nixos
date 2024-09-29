{lib, ...}: let
  inherit
    (lib)
    attrNames
    attrValues
    replaceStrings
    ;
in {
  strings = {
    replaceUsing = replacements: str:
      replaceStrings
      (attrNames replacements)
      (attrValues replacements)
      str;
  };
}
