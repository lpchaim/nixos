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
        env = {
          EDITOR = "hx";
          NH_FLAKE = inputs.self.lib.config.flake.path;
        };
        packages =
          (with pkgs; [
            bat
            fish
            git
            helix
            just
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
