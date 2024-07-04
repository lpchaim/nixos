{ config, inputs, lib, pkgs, ... }:

let
  namespace = [ "my" "modules" "de" "hyprland" "bars" "ags" ];
  cfg = lib.getAttrFromPath namespace config;
in
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "AGS";
    enableFnKeys = lib.mkEnableOption "function key bindings";
  };

  config =
    let
      pythonWithMaterialYouColor = (pkgs.python311.withPackages (p: with p; [
        pkgs.lpchaim."pythonPackages.materialyoucolor"
        # material-color-utilities
        pywayland
        setproctitle
      ]));
      dependencies =
        [ pythonWithMaterialYouColor ]
        ++ (import ./deps.nix pkgs)
        ++ (with pkgs.gnome; [
          gnome-bluetooth
          gnome-control-center
        ]);
    in
    lib.mkIf cfg.enable (lib.mkMerge [
      {
        programs.ags = {
          enable = true;
          package = inputs.ags.packages.${pkgs.system}.ags.overrideAttrs (prev: {
            nativeBuildInputs = prev.nativeBuildInputs
              ++ dependencies
              ++ (with pkgs; [
              gjs
              wrapGAppsHook3
            ]);
            buildInputs = prev.buildInputs
              ++ dependencies
              ++ (with pkgs; [
              linux-pam
            ]);
          });
          configDir = pkgs.stdenvNoCC.mkDerivation {
            name = "ags-config";
            src = inputs.dots-hyprland;
            buildPhase = ''
              mkdir -p $out
              cp -r $src/.config/ags/. $out/
              chmod -R +w $out
              cp $out/scss/fallback/_material.scss \
                $out/scss/_material.scss # TODO Workaround until I manage to generate this through a derivation
            '';
          };
        };

        home = {
          packages = dependencies;
          sessionVariables = {
            GTK_THEME = "Adwaita-dark";
            XCURSOR_THEME = "Adwaita";
          };
        };

        wayland.windowManager.hyprland.settings.exec-once = lib.mkBefore [ "ags" ];
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
