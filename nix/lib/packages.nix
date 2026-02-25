{
  inputs,
  lib,
  ...
}: let
  overlays = builtins.attrValues inputs.self.overlays;
in {
  callPackageRecursiveWith = pkgs: path: extraArgs:
    lib.packagesFromDirectoryRecursive {
      callPackage = lib.callPackageWith (pkgs // extraArgs);
      directory = path;
    }
    |> lib.filterAttrsRecursive (name: _: name != "default");
  callPackageWith = pkgs: path: extraArgs:
    lib.callPackageWith
    pkgs
    (
      if (lib.pathIsDirectory path && builtins.pathExists "${path}/package.nix")
      then "${path}/package.nix"
      else if (lib.pathIsDirectory path && builtins.pathExists "${path}/default.nix")
      then "${path}/default.nix"
      else path
    )
    extraArgs;
  mkPkgs = {
    system,
    nixpkgs ? inputs.nixpkgs,
  }:
    import nixpkgs {
      inherit system overlays;
      allowUnfree = true;
    };
}
