{
  config,
  lib,
  pkgs,
  ...
}: {
  mkShell = args: let
    shellHook = args.shellHook or "";
    nativeBuildInputs = args.nativeBuildInputs or [];
    fullArgs =
      args
      // {
        nativeBuildInputs =
          nativeBuildInputs
          ++ config.pre-commit.settings.enabledPackages
          ++ (lib.optionals (config.pre-commit.settings.package != null) [
            config.pre-commit.settings.package
          ])
          ++ (with pkgs; [
            age
            alejandra
            nh
            nil
            nixos-generators
            nixpkgs-fmt
            ssh-to-age
            snowfallorg.flake
            sops
          ]);
        shellHook =
          config.pre-commit.installationScript
          + (lib.optionalString (shellHook != "") shellHook);
      };
  in
    pkgs.mkShell fullArgs;
}
