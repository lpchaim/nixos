{
  config,
  lib,
  pkgs,
  ...
}: {
  mkShell = args: let
    shellHook = args.shellHook or "";
    nativeBuildInputs = args.packages or [];
    fullArgs =
      (builtins.removeAttrs args ["packages"])
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
            nil
            nixpkgs-fmt
            ssh-to-age
            sops
          ]);
        shellHook =
          config.pre-commit.installationScript
          + (lib.optionalString (shellHook != "") shellHook);
      };
  in
    pkgs.mkShell fullArgs;
}
