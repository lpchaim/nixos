{
  inputs,
  lib,
  self,
  ...
}: let
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
      ci.matrix = callPackage ./ciMatrix.nix {inherit self;};
      scripts = callPackageRecursive ./scripts {inherit (self'.legacyPackages.pkgs) writeNuScriptStdinBin;};
      vimPlugins = callPackageRecursive ./vimPlugins {};
      knownHosts =
        self.vars.hosts
        |> lib.mapAttrsToList (host: cfg: "${host} ${cfg.pubKey}")
        |> lib.concatStringsSep "\n"
        |> pkgs.writeText "known-hosts";
    };
  };
}
