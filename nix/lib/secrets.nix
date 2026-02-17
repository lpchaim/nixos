rec {
  paths = rec {
    root = ../../secrets;
    identities = root + /identities;
    perHost = root + /perHost;
    perUser = root + /perUser;
  };
  identities = {
    primaryYubikey = {
      identity = paths.identities + /age-yubikey-identity-25388788.pub;
      pubkey = "age1yubikey1qd4evthtmz779wrj5j92j46jgxu87are20rxagx609vs3z3g5535j2jtsrt";
    };
    secondaryYubikey = {
      identity = paths.identities + /age-yubikey-identity-26583315.pub;
      pubkey = "age1yubikey1qvsexaz0mrwzd6eadgmnupexs0csw6esdzmfzs3eehmn4w4hdlch5j7xrxs";
    };
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
