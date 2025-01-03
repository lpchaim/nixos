{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.llm.high;
in {
  options.my.profiles.llm.high = lib.mkEnableOption "High LLM preset profile";
  config.my.modules.misc.llm = lib.mkIf cfg {
    enable = true;
    defaultModel = "llama3";
  };
}
