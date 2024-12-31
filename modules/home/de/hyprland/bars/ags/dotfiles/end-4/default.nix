{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  pythonWithMaterialYouColor = pkgs.python311.withPackages (p:
    with p; [
      (python3Packages.buildPythonPackage rec {
        pname = "materialyoucolor";
        version = "2.0.9";

        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-J35//h3tWn20f5ej6OXaw4NKnxung9q7m0E4Zf9PUw4=";
        };

        doCheck = false;

        meta = {
          homepage = "https://github.com/T-Dynamos/materialyoucolor-python";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [lpchaim];
        };
      })
      # material-color-utilities
      pywayland
      setproctitle
    ]);
  dependencies =
    (import ./deps.nix pkgs)
    ++ [
      pythonWithMaterialYouColor
      pkgs.gnome-bluetooth
      pkgs.gnome.gnome-control-center
    ];
  cfg = config.my.modules.de.hyprland.bars.ags.dotfiles.end-4;
in {
  options.my.modules.de.hyprland.bars.ags.dotfiles.end-4 = {
    enable = lib.mkEnableOption "end-4's ags dotfiles";
    enableFnKeys = lib.mkEnableOption "function key bindings";
  };
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.ags = {
        package = inputs.ags.packages.${pkgs.system}.ags.overrideAttrs (prev: {
          nativeBuildInputs =
            prev.nativeBuildInputs
            ++ dependencies
            ++ (with pkgs; [
              gjs
              wrapGAppsHook3
            ]);
          buildInputs =
            prev.buildInputs
            ++ dependencies
            ++ (with pkgs; [
              linux-pam
            ]);
        });
        configDir = pkgs.stdenvNoCC.mkDerivation {
          name = "ags-config";
          src = inputs.dotfiles-end-4;
          buildPhase = ''
            mkdir -p $out
            cp -r $src/.config/ags/. $out/
            chmod -R +w $out
            cp $out/scss/fallback/_material.scss \
              $out/scss/_material.scss # TODO Workaround until I manage to generate this through a derivation
          '';
        };
      };
      home.packages = dependencies;
    }
    (lib.mkIf cfg.enableFnKeys {
      wayland.windowManager.hyprland.settings = {
        binde = lib.mkAfter [
          ", XF86AudioRaiseVolume, exec, ags run-js 'indicator.popup(1)'"
          ", XF86AudioLowerVolume, exec, ags run-js 'indicator.popup(1)'"
          ", XF86AudioMute, exec, ags run-js 'indicator.popup(1)'"
          ", XF86MonBrightnessDown, exec, ags run-js 'indicator.popup(1)'"
          ", XF86MonBrightnessUp, exec, ags run-js 'indicator.popup(1)'"
        ];
      };
    })
  ]);
}
