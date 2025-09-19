args: {
  imports = [
    ./assets.nix
    (import ./ci.nix args)
  ];
}
