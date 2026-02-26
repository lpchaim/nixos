{
  inputs,
  withSystem,
  ...
}: let
  inherit (inputs.self.lib) mkPkgs;
in {
  flake.nixOnDroidConfigurations = withSystem "aarch64-linux" ({system, ...}: let
    pkgs = mkPkgs {
      inherit system;
      extraOverlays = [inputs.nix-on-droid.overlays.default];
    };
  in {
    default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      inherit pkgs;
      modules = [
        ({...}: {
          environment.etcBackupExtension = ".bak";

          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';

          home-manager = {
            config = {
              home.stateVersion = "24.05";
            };
            backupFileExtension = ".bak";
            useGlobalPkgs = true;
          };

          system.stateVersion = "24.05";
        })
      ];
      extraSpecialArgs = {
        inherit inputs;
        rootPath = ./.;
      };
    };
  });
}
