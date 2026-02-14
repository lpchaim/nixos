{
  config,
  inputs,
  lib,
  options,
  pkgs,
  osConfig ? {},
  ...
}: let
  cfg = config.my.security;
in {
  options.my.security = {
    enable =
      lib.mkEnableOption "security settings"
      // {default = osConfig.my.security.enable or false;};
    residentKeys = {
      private = lib.mkOption {
        description = "private resident key handles";
        type = with lib.types; listOf str;
        default = [];
      };
      public = lib.mkOption {
        description = "public resident keys";
        inherit (options.my.security.residentKeys.private) type default;
      };
      all = lib.mkOption {
        description = "all resident keys";
        inherit (options.my.security.residentKeys.private) type default;
      };
    };
  };

  config = let
    path = inputs.self + /keys/resident;
    keys =
      path
      |> builtins.readDir
      |> lib.filterAttrs (_: type: type == "regular");
  in
    lib.mkIf cfg.enable {
      my.security.residentKeys = let
        getLocalPaths = filterFn:
          keys
          |> lib.mapAttrs (name: _: "${config.home.homeDirectory}/.ssh/" + name)
          |> lib.attrValues
          |> builtins.filter filterFn;
      in rec {
        private = getLocalPaths (name: !(lib.hasSuffix ".pub" name));
        public = getLocalPaths (name: lib.hasSuffix ".pub" name);
        all = private ++ public;
      };

      home = {
        file =
          keys
          |> lib.mapAttrs (name: _: (path + name) |> builtins.toPath)
          |> lib.concatMapAttrs (name: path: {
            ".ssh/${name}" = {
              source = path;
            };
          });
        packages =
          (with pkgs; [
            yubikey-manager
            yubikey-personalization
          ])
          ++ lib.optionals config.my.profiles.graphical [
            pkgs.yubioath-flutter
          ];
      };
    };
}
