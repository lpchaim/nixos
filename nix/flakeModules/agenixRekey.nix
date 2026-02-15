{inputs, ...}: {
  imports = [
    inputs.agenix-rekey.flakeModule
  ];

  perSystem = {pkgs, ...}: {
    agenix-rekey = {
      inherit (inputs.self) nixosConfigurations;
      agePackage = pkgs.rage;
      collectHomeManagerConfigurations = false;
      homeConfigurations = {};
    };
  };
}
