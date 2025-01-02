{
  config,
  lib,
  ...
}: let
  cfg = config.my.traits.llm.mid;
in {
  options.my.traits.llm.mid.enable = lib.mkEnableOption "Mid LLM preset trait";
  config.my.modules.misc.llm = lib.mkIf cfg.enable {
    enable = true;
    defaultModel = "phi2";
  };
}
