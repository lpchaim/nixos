{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs self;
  inherit (inputs.haumea.lib) load transformers;
  inherit (nixpkgs) lib;
  myLib = load {
    src = self + /lib;
    inputs = {
      inherit inputs;
      inherit lib;
    };
    transformer = with transformers; [
      liftDefault
    ];
  };
in {
  internal =
    builtins.mapAttrs
    (k: v: v.${k} or v)
    myLib;
}
