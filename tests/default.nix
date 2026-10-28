{inputs, ...}: {
  imports = [
    inputs.nixtest.flakeModule
    ./nixos.nix
    ./unit.nix
  ];
}
