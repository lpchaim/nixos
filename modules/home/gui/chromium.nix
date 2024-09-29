{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.home-manager.lib) hm;
in
  lib.mkIf (config.my.modules.gui.enable) {
    programs.chromium = {
      enable = true;
      commandLineArgs = [
        "--disable-gpu-compositing" # @TODO Remove after NVIDIA figures this out
      ];
      package = pkgs.brave;
    };

    home.activation.patchBraveWebapps = let
      inherit (config.programs.chromium) package;
      executable = package.meta.mainProgram;
      script =
        hm.dag.entryAfter
        ["writeBoundary"]
        # bash
        ''
          # Patches webapps so that they point to the executable on path
          run --quiet \
          find '${config.home.homeDirectory}/.local/share/applications' \
            -type f -name 'brave-*.desktop' \
          | xargs --no-run-if-empty \
            sed --in-place 's,Exec=[^ ]*,Exec=${executable},g'
        '';
    in
      lib.mkIf (package == pkgs.brave) script;
  }
