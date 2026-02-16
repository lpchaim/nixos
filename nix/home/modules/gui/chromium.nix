{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.home-manager.lib) hm;
  cfg = config.my.gui.chromium;
in {
  options.my.gui.chromium.enable =
    lib.mkEnableOption "custom chromium"
    // {default = config.my.gui.enable;};

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      commandLineArgs =
        [
          "--password-store=gnome"
        ]
        ++ (lib.optionals (config.my.profiles.hardware.gpu.nvidia) [
          "--disable-gpu-compositing" # @TODO Remove after NVIDIA figures this out
        ]);
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
  };
}
