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
  mkHostSecret = host: name: args:
    args
    // {
      rekeyFile = perHost + /${host}/${name}.age;
    };
  mkUserSecret = user: name: args:
    args
    // {
      rekeyFile = perUser + /${user}/${name}.age;
    };
}
