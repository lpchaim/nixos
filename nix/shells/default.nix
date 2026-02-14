{inputs, ...}: {
  imports = [
    inputs.make-shell.flakeModules.default
    ./deploy.nix
    ./nix.nix
    ./rust.nix
    ./minimal.nix
  ];

  perSystem = {
    config,
    self',
    ...
  }: {
    devShells.default = self'.devShells.nix;
    make-shell.imports = [
      ({
        lib,
        pkgs,
        ...
      }: {
        env = {
          EDITOR = "hx";
        };
        packages =
          (with pkgs; [
            agenix-rekey
            bat
            fish
            git
            helix
            just
            rage
          ])
          ++ config.pre-commit.settings.enabledPackages
          ++ lib.optionals (config.agenix-rekey.package != null) [
            config.agenix-rekey.package
          ]
          ++ lib.optionals (config.pre-commit.settings.package != null) [
            config.pre-commit.settings.package
          ];
        shellHook = config.pre-commit.installationScript;
      })
    ];
  };
}
