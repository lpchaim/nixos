{
  config,
  lib,
  ...
}: let
  mutableOption = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({config, ...}: {
      options = {
        mutable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };
      config = lib.mkIf (config.mutable) {
        onChange = ''
          cp --remove-destination $(readlink '${config.target}') '${config.target}'
          chmod u+w '${config.target}'
        '';
      };
    }));
  };
in {
  options = {
    home.file = mutableOption;
  };
  config = {
    assertions =
      config.home.file
      |> lib.filterAttrs (_: file: file.enable && file.mutable)
      |> lib.mapAttrsToList (name: file: [
        {
          assertion = !file.recursive;
          message = "Mutable files can't be recursive";
        }
      ])
      |> lib.flatten;
  };
}
