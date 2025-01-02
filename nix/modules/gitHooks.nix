{inputs, ...}: {
  imports = [
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem = {
    config,
    system,
    pkgs,
    ...
  }: let
    pkgs = inputs.self.pkgs.${system};
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
