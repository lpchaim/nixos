{
  config,
  pkgs,
  ...
}: {
  environment = {
    # @TODO Rethink this
    systemPackages = [
      (pkgs.writeShellScriptBin "atuin-init" ''
        atuin login --username lpchaim \
          --password "$(cat ${config.age.secrets."atuin-password".path})" \
          --key "$(cat ${config.age.secrets."atuin-key".path})"
      '')
    ];
  };
}
