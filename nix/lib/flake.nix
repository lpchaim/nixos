{lib, ...}: rec {
  getStandaloneHomeConfigurations = self:
    self.homeConfigurations
    |> lib.filterAttrs (name: _: isStandaloneHome self.nixosConfigurations name);

  isStandaloneHome = nixosConfigurations: name:
    !(nixosConfigurations ? ${name |> lib.splitString "@" |> lib.last});

  parseHomeName = home: let
    splitName = lib.splitString "@" home;
    user = lib.head splitName;
    host =
      if (builtins.length splitName > 1)
      then lib.last splitName
      else null;
  in {inherit user host;};
}
