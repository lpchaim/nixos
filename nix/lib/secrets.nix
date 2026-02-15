rec {
  root = ../../secrets;
  identities = root + /identities;
  perHost = root + /perHost;
  perUser = root + /perUser;
  mkSecret = name: args:
    args
    // {
      rekeyFile = root + /${name}.age;
    };
  mkHostSecret = configOrHost: name: args:
    args
    // {
      rekeyFile = let
        host = configOrHost.networking.hostName or configOrHost;
      in
        perHost + /${host}/${name}.age;
    };
  mkUserSecret = configOrUser: name: args:
    args
    // {
      rekeyFile = let
        user = configOrUser.home.username or configOrUser;
      in
        perUser + /${user}/${name}.age;
    };
}
