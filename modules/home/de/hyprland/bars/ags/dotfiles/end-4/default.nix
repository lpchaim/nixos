{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  pythonWithMaterialYouColor = pkgs.python311.withPackages (p:
    with p; [
      pkgs.lpchaim."pythonPackages.materialyoucolor"
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
in
  lib.lpchaim.mkModule {
    inherit config;
    description = "end-4's ags dotfiles";
    namespace = "my.modules.de.hyprland.bars.ags.dotfiles.end-4";
    options = {
      enableFnKeys = lib.mkEnableOption "function key bindings";
    };
    configBuilder = cfg:
      lib.mkIf cfg.enable (lib.mkMerge [
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
