{inputs, ...}: {
  imports = [
    inputs.nixtest.flakeModule
    ./nixos.nix
    ./nixosSnapshots.nix
  ];
}
