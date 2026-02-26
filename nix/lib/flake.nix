{lib, ...}: rec {
  getStandaloneHomeConfigurations = self:
    self.homeConfigurations
    |> lib.filterAttrs (name: _: isStandaloneHome self.nixosConfigurations name);
  isStandaloneHome = nixosConfigurations: name:
    !(nixosConfigurations ? ${name |> lib.splitString "@" |> lib.last});
}
