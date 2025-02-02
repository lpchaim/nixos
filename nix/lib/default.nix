{inputs, ...} @ topLevelArgs: let
  inherit (inputs.nixpkgs) lib;
  args = topLevelArgs // {inherit lib;};
  overlays = builtins.attrValues inputs.self.overlays;
in {
  config = import ./config.nix args;
  loaders = import ./loaders.nix args;
  shell = import ./shell.nix;
  storage = import ./storage args;
  strings = import ./strings.nix args;

  mkPkgs = {
    system,
    nixpkgs ? inputs.nixpkgs,
  }:
    import nixpkgs {
      inherit system overlays;
      allowUnfree = true;
    };
  isNvidia = config: let
    drivers = config.services.xserver.videoDrivers or [];
  in
    builtins.elem "nvidia" drivers;
}
