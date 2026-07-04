{
  inputs,
  lib,
  self,
  ...
} @ args: {
  flake = import ./flake.nix args;
  oci = import ./oci.nix args;
  packages = import ./packages.nix args;
  secrets = import ./secrets.nix args;
  services = import ./services.nix args;
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
  nixFilesToAttrs = path:
    builtins.readDir path
    |> lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix")
    |> lib.concatMapAttrs (relativePath: _: {
      ${relativePath |> lib.removeSuffix ".nix"} = path + /${relativePath};
    });
}
