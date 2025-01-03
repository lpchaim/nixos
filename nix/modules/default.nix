args: {
  imports = [
    (import ./ezConfigs.nix args)
    (import ./gitHooks.nix args)
  ];
}
