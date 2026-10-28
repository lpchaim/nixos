{
  inputs,
  self,
  ...
}: let
  inherit (self.lib) callPackageWith callPackageRecursiveWith;
in {
  perSystem = {
    self',
    pkgs,
    system,
    ...
  }: let
    callPackage = callPackageWith pkgs;
    callPackageRecursive = callPackageRecursiveWith pkgs;
  in {
    legacyPackages = {
      ci.matrix = callPackage ./ciMatrix.nix {inherit self;};
      knownHosts = callPackage ./knownHosts.nix {inherit self;};
      pkgs = self.lib.mkPkgs {
        inherit system;
        inherit (inputs) nixpkgs;
      };
      scripts = callPackageRecursive ./scripts {inherit (self'.legacyPackages.pkgs) writers;};
      vimPlugins = callPackageRecursive ./vimPlugins {};
    };
  };
}
