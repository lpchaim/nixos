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
    pkgs,
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
        packages =
          (with pkgs; [
            bat
            fish
            git
            helix
          ])
          ++ config.pre-commit.settings.enabledPackages
          ++ (lib.optionals (config.pre-commit.settings.package != null) [
            config.pre-commit.settings.package
          ]);
        shellHook = config.pre-commit.installationScript;
      })
    ];
  };
}
