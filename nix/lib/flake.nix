{lib, ...}: {
  getStandaloneHomeConfigurations = self:
    self.homeConfigurations
    |> lib.filterAttrs (name: _: self.lib.isStandaloneHome self.nixosConfigurations name);
  isStandaloneHome = nixosConfigurations: name:
    !(nixosConfigurations ? ${name |> lib.splitString "@" |> lib.last});
}
