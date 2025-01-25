{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.config) name;
in {
  sops.secrets =
    lib.genAttrs
    [
      "atuin/key"
      "atuin/password"
      "atuin/username"
    ]
    (_: {owner = name.user;});
  environment = {
    systemPackages = [
      (pkgs.writeShellScriptBin "atuin-init" ''
        atuin login --username "$(cat ${config.sops.secrets."atuin/username".path})" \
          --password "$(cat ${config.sops.secrets."atuin/password".path})" \
          --key "$(cat ${config.sops.secrets."atuin/key".path})"
      '')
    ];
  };
}
