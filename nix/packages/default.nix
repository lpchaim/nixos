{inputs, ...}: {
  imports = [
    inputs.pkgs-by-name-for-flake-parts.flakeModule
  ];

  perSystem = {
    inputs',
    lib,
    pkgs,
    ...
  }: let
    callPackage = lib.callPackageWith pkgs;
  in {
    pkgsDirectory = ./.;
    pkgsNameSeparator = "-";
    packages = lib.mkForce {
      lichen =
        callPackage
        ./lichen/package.nix
        {inherit (inputs'.nixpkgs-hare.legacyPackages) hare hareHook;};
    };
  };
}
