{lib, ...}: let
  inherit (lib) hasPrefix removePrefix removeSuffix replaceStrings stringToCharacters;
  inherit (lib.strings) normalizePath escapeC;

  # Taken from https://github.com/NixOS/nixpkgs/blob/c523da2ac5901323fd7b7f9950816b67309894ac/nixos/lib/utils.nix
  escapeSystemdPath = s: let
    replacePrefix = p: r: s: (
      if (hasPrefix p s)
      then r + (removePrefix p s)
      else s
    );
    trim = s: removeSuffix "/" (removePrefix "/" s);
    normalizedPath = normalizePath s;
  in
    replaceStrings ["/"] ["-"] (
      replacePrefix "." (escapeC ["."] ".") (
        escapeC (stringToCharacters " !\"#$%&'()*+,;<=>=@[\\]^`{|}~-") (
          if normalizedPath == "/"
          then normalizedPath
          else trim normalizedPath
        )
      )
    );
in {
  escapePath = escapeSystemdPath;
}
