{lib, ...}: rec {
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
  generators = rec {
    mkEnvGenerator = args: attrs: let
      str =
        builtins.attrNames attrs
        |> lib.concatMapStrings (name: ''
          ${name}="%s"
        '');
      subs = builtins.attrValues attrs;
    in
      mkPrintfGenerator args str subs;
    mkEnvsubstGenerator = args: string: env:
      args
      // {
        dependencies =
          builtins.attrValues env
          |> lib.flatten
          |> (secrets: lib.genAttrs' secrets (secret: lib.nameValuePair secret.name secret));
        script = {
          lib,
          decrypt,
          deps,
          ...
        }: let
          envs =
            env
            |> lib.mapAttrsToList (name: secret: ''${name}="$(${decrypt} ${lib.escapeShellArg deps.${secret.name}.file})"'')
            |> lib.concatStringsSep " ";
        in ''
          echo ${lib.escapeShellArg string} | ${envs} envsubst
        '';
      };
    mkPrintfGenerator = args: string: subs:
      args
      // {
        dependencies = lib.genAttrs' subs (secret: lib.nameValuePair secret.name secret);
        script = {
          lib,
          decrypt,
          deps,
          ...
        }: let
          args =
            subs
            |> map (secret: ''"$(${decrypt} ${lib.escapeShellArg deps.${secret.name}.file})"'')
            |> lib.concatStringsSep " ";
        in ''
          printf ${lib.escapeShellArg string} ${args}
        '';
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
          host = configOrHost.networking.hostName
            or configOrHost.my.hostName
            or configOrHost;
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
