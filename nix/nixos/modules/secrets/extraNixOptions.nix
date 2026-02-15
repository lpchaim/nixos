{config, ...}: {
  nix.extraOptions = ''
    !include ${config.age.secrets."nix-extra-access-tokens".path}
  '';
}
