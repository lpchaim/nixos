{inputs, ...} @ args: let
  inherit (inputs.self.lib) callPackageWith callPackageRecursiveWith;
in {
  perSystem = {
    self',
    pkgs,
    ...
  }: let
    callPackage = callPackageWith pkgs;
    callPackageRecursive = callPackageRecursiveWith pkgs;
  in {
    legacyPackages = {
      ci.matrix = callPackage ./ciMatrix.nix {inherit (args.inputs) self;};
      scripts = callPackageRecursive ./scripts {inherit (self'.legacyPackages.pkgs) writeNuScriptStdinBin;};
    };
  };
}
