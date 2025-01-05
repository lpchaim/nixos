{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.config) name;
in {
  sops.secrets = let
    owner = name.user;
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
