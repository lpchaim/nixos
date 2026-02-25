{
  inputs,
  self,
  ...
}: let
  inherit (self.lib) getStandaloneHomeConfigurations;
in {
  imports = [
    inputs.agenix-rekey.flakeModule
  ];

  perSystem = {pkgs, ...}: {
    agenix-rekey = {
      inherit (self) nixosConfigurations;
      agePackage = pkgs.rage;
      homeConfigurations = getStandaloneHomeConfigurations self;
    };
  };
}
