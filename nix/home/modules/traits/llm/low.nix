{
  config,
  lib,
  ...
}: let
  cfg = config.my.traits.llm.low;
in {
  options.my.traits.llm.low.enable = lib.mkEnableOption "Low LLM preset trait";
  config.my.modules.misc.llm = lib.mkIf cfg.enable {
    enable = true;
    defaultModel = "tinyllama";
  };
}
