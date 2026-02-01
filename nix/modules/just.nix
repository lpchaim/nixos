{inputs, ...}: let
  inherit (inputs) self;
  inherit (inputs.nixpkgs) lib;
in {
  imports = [
    inputs.ez-configs.flakeModule
  ];
}
