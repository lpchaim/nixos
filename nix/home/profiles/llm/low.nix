{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.llm.low;
in {
  options.my.profiles.llm.low = lib.mkEnableOption "Low LLM preset profile";
  config.my.misc.llm = lib.mkIf cfg {
    enable = true;
    defaultModel = "tinyllama";
  };
}
