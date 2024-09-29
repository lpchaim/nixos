{inputs, ...}: let
  inherit (inputs) self;
in
  final: prev: {
    inherit (inputs.omnix.packages.${prev.system}) omnix-cli;
    nix-conf = let
      homeCfg = self.legacyPackages.${prev.system}.homeConfigurations.minimal.config.home;
      nixCfg = homeCfg.file."${homeCfg.homeDirectory}/.config/nix/nix.conf".source;
    in
      nixCfg;
    writeNushellScript = name: text:
      prev.writeScript name ''
        #!${prev.nushell}/bin/nu

        ${text}
      '';
    writeNushellScriptBin = name: text:
      prev.writeScriptBin name ''
        #!${prev.nushell}/bin/nu

        ${text}
      '';
  }
