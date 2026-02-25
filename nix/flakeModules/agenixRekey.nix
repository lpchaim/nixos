{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.agenix-rekey.flakeModule
  ];

  perSystem = {pkgs, ...}: {
    agenix-rekey = {
      inherit (self) nixosConfigurations;
      agePackage = pkgs.rage;
      homeConfigurations = self.lib.getStandaloneHomeConfigurations self;
    };
  };
}
