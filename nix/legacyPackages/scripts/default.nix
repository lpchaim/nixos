{inputs, ...}: let
  inherit (inputs.self.lib) nixFilesToAttrs;
in {
  perSystem = {
    self',
    lib,
    pkgs,
    ...
  }: {
    legacyPackages = let
      callPackage = lib.callPackageWith pkgs;
      extraPkgs = {inherit (self'.legacyPackages.pkgs) writeNuScriptStdinBin;};
      scripts =
        nixFilesToAttrs ./.
        |> lib.mapAttrs (_: path: callPackage path extraPkgs);
    in
      scripts # Provide them at the top level as well so they're more convenient to run
      // {inherit scripts;};
  };
}
