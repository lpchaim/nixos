{
  inputs,
  lib,
  self,
  ...
} @ args: {
  flake = import ./flake.nix args;
  hyprland = import ./hyprland.nix args;
  packages = import ./packages.nix args;
  secrets = import ./secrets.nix args;
  services = import ./services.nix args;
  systemd = import ./systemd.nix args;
  storage = import ./storage args;
  strings = import ./strings.nix args;

  inherit
    (self.lib.flake)
    getStandaloneHomeConfigurations
    ;
  inherit
    (self.lib.packages)
    callPackageRecursiveWith
    callPackageWith
    mkPkgs
    ;

  carapaceSpecFromNuScript = script: let
    inherit (script) name system;
    inherit (inputs.self.legacyPackages.${system}) scripts pkgs;
  in
    pkgs.runCommand
    "nushell-carapace-spec-${name}"
    {
      buildInputs = with scripts; [
        nu-generate-carapace-spec
        nu-inspect
      ];
    }
    ''
      cat '${lib.getExe script}' \
      | nu-inspect --name '${name}' \
      | nu-generate-carapace-spec \
      > $out
    '';

  importDir = path:
    builtins.readDir path
    |> lib.filterAttrs (name: type: type == "directory" || (lib.hasSuffix ".nix" name && name != "default.nix"))
    |> lib.mapAttrs' (name: type: {
      name = lib.removeSuffix ".nix" name;
      value =
        if type != "directory" || builtins.pathExists (path + /${name}/default.nix)
        then import (path + /${name})
        else null;
    })
    |> lib.filterAttrs (_: content: content != null);

  mkStableNumericId = maxCharacters: seed:
    builtins.hashString "sha256" (seed |> toString |> lib.trim)
    |> inputs.nix-std.lib.regex.substitute "[^[:digit:]]" ""
    |> inputs.nix-std.lib.regex.substitute "^0+" ""
    |> (chars:
      if maxCharacters != null
      then (lib.substring 0 maxCharacters chars)
      else chars);

  mkStableUuid = seed: let
    h = builtins.hashString "sha256" (seed |> toString |> lib.trim);
  in
    lib.concatStringsSep "-" [
      (builtins.substring 0 8 h)
      (builtins.substring 8 4 h)
      (builtins.substring 12 4 h)
      (builtins.substring 16 4 h)
      (builtins.substring 20 12 h)
    ];

  nixFilesToAttrs = path:
    builtins.readDir path
    |> lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix")
    |> lib.concatMapAttrs (relativePath: _: {
      ${relativePath |> lib.removeSuffix ".nix"} = path + /${relativePath};
    });
}
