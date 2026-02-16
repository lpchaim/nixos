rec {
  paths = rec {
    root = ../../secrets;
    identities = root + /identities;
    perHost = root + /perHost;
    perUser = root + /perUser;
  };
  helpers = {
    mkSecret = name: args:
      args
      // {
        rekeyFile = paths.root + /${name}.age;
      };
    mkHostSecret = configOrHost: name: args:
      args
      // {
        rekeyFile = let
          host = configOrHost.networking.hostName or configOrHost;
        in
          paths.perHost + /${host}/${name}.age;
      };
    mkUserSecret = configOrUser: name: args:
      args
      // {
        rekeyFile = let
          user = configOrUser.home.username or configOrUser;
        in
          paths.perUser + /${user}/${name}.age;
      };
  };
}
