{ config, inputs, lib, pkgs, ... }:

with lib;
let
  namespace = [ "my" "modules" "de" "hyprland" "bars" "ags" ];
  cfg = getAttrFromPath namespace config;
in
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  options = setAttrByPath namespace {
    enable = mkEnableOption "AGS";
  };

  config =
    let
      pythonWithMaterialYouColor = (pkgs.python311.withPackages (p: with p; [
        (buildPythonPackage rec {
          pname = "materialyoucolor";
          version = "2.0.9";
          src = fetchPypi {
            inherit pname version;
            sha256 = "sha256-J35//h3tWn20f5ej6OXaw4NKnxung9q7m0E4Zf9PUw4=";
          };
          doCheck = false;
        })
        # material-color-utilities
        pywayland
        setproctitle
      ]));
      dependencies = [ pythonWithMaterialYouColor ]
        ++ (import ./deps.nix pkgs)
        ++ (with pkgs.gnome; [
        gnome-bluetooth
        gnome-control-center
        gnome-keyring
      ]);
    in
    mkIf cfg.enable {
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
        # extraPackages = dependencies;
      };

      home = {
        file = {
          # ".local/state/ags/user/ai/google_key.txt".content = ""; # TODO Add API key as secret
        };
        packages = dependencies;
        sessionVariables = {
          GTK_THEME = "Adwaita-dark";
          XCURSOR_THEME = "Adwaita";
        };
      };

      wayland.windowManager.hyprland.settings.exec-once = [ "ags" ];
    };
}
