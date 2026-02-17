{inputs, ...}: {
  imports = [
    inputs.make-shell.flakeModules.default
    ./deploy.nix
    ./maintenance.nix
    ./minimal.nix
    ./nix.nix
    ./rust.nix
  ];

  perSystem = {self', ...}: {
    devShells.default = self'.devShells.maintenance;
    make-shell.imports = [
      ({pkgs, ...}: {
        env.EDITOR = "hx";
        packages = with pkgs; [
          bat
          fish
          git
          helix
        ];
      })
    ];
  };
}
