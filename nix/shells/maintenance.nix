{inputs, ...}: let
  inherit (inputs.self.lib.secrets.identities) primaryYubikey secondaryYubikey;
in {
  perSystem = {
    config,
    lib,
    pkgs,
    self',
    ...
  }: {
    make-shells.maintenance = {
      additionalArguments.meta.description = "Maintenance environment";
      additionalArguments.passthru.my.ci.buildFor = ["x86_64-linux"];

      env = {
        AGENIX_PUBKEY_PRIMARY = primaryYubikey.pubkey;
        AGENIX_PUBKEY_SECONDARY = secondaryYubikey.pubkey;
      };
      inputsFrom = with self'.devShells; [
        nix
      ];
      packages =
        (with pkgs; [
          age-plugin-yubikey
          agenix-rekey
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
    };
  };
}
