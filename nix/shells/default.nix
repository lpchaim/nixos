{inputs, ...}: let
  inherit (inputs.self.lib.secrets.identities) primaryYubikey secondaryYubikey;
in {
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
          AGENIX_PUBKEY_PRIMARY = primaryYubikey.pubkey;
          AGENIX_PUBKEY_SECONDARY = secondaryYubikey.pubkey;
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
        shellHook =
          config.pre-commit.installationScript
          + ''
            if [[ "$HOSTNAME" == "desktop" ]]; then
              export AGENIX_REKEY_PRIMARY_IDENTITY="$AGENIX_PUBKEY_PRIMARY"

            else
              export AGENIX_REKEY_PRIMARY_IDENTITY="$AGENIX_PUBKEY_SECONDARY"
            fi
          '';
      })
    ];
  };
}
