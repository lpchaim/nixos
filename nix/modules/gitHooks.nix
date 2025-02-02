{inputs, ...}: {
  imports = [
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem = {
    config,
    system,
    pkgs,
    self',
    ...
  }: let
    inherit (self'.legacyPackages) pkgs;
  in {
    pre-commit = {
      inherit pkgs;
      check.enable = true;
      settings = {
        hooks.actionlint.enable = true;
        hooks.alejandra.enable = true;
        hooks.ripsecrets.enable = true;
      };
    };
  };
}
