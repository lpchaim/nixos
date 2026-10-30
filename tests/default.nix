{inputs, ...}: {
  imports = [
    inputs.nixtest.flakeModule
    ./home.nix
    ./nixos.nix
    ./unit.nix
  ];
}
