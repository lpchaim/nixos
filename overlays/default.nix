{inputs, ...}: let
  inherit (inputs) self;
in
  final: prev: {
    inherit (inputs.omni.packages.${prev.system}) omnix-cli;
    nix-conf = let
      homeCfg = self.legacyPackages.${prev.system}.homeConfigurations.minimal.config.home;
      nixCfg = homeCfg.file."${homeCfg.homeDirectory}/.config/nix/nix.conf".source;
    in
      nixCfg;
    writeNushellScript = name: text:
      prev.writeScript "nushell-${name}" ''
        #! ${prev.nushell}/bin/nu
        ${text}
      '';
    writeNushellScriptBin = name: text:
      prev.writeScriptBin "nushell-${name}" ''
        #! ${prev.nushell}/bin/nu
        ${text}
      '';
  }
