{inputs, ...}: {
  imports = [
    inputs.agenix-rekey.flakeModule
  ];

  perSystem = {pkgs, ...}: {
    agenix-rekey = {
      inherit (inputs.self) homeConfigurations nixosConfigurations;
      agePackage = pkgs.rage;
    };
  };
}
