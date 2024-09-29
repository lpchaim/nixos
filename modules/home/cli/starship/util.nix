{
  pkgs,
  lib,
  ...
}:
with lib; let
  makePreset = name:
    pkgs.runCommand
    "starship-preset-${name}"
    {buildInputs = [pkgs.starship];}
    "starship preset ${name} > $out";
  getPresetFile = name: readFile (makePreset name);
in {
  getPresetFiles = names: (map getPresetFile) names;
}
