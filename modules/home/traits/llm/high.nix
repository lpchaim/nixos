{
  config,
  lib,
  ...
}: let
  cfg = config.my.traits.llm.high;
in {
  options.my.traits.llm.high.enable = lib.mkEnableOption "High LLM preset trait";
  config.my.modules.misc.llm = lib.mkIf cfg.enable {
    enable = true;
    defaultModel = "llama3";
  };
}
