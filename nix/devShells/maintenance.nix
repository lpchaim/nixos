{inputs, ...}: let
  inherit (inputs.self.lib.secrets.identities) primaryYubikey secondaryYubikey;
in {
  perSystem = {
    config,
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
          just
          rage
          yaml-language-server
        ])
        ++ (with config; [
          agenix-rekey.package
          files.writer.drv
          pre-commit.settings.package
          treefmt.build.wrapper
        ])
        ++ config.pre-commit.settings.enabledPackages;
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
