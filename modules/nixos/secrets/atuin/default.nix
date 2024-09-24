{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.lpchaim.shared) defaults;
in {
  sops.secrets = let
    owner = defaults.name.user;
  in {
    "atuin/username" = {inherit owner;};
    "atuin/password" = {inherit owner;};
    "atuin/key" = {inherit owner;};
  };
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
