{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.llm.mid;
in {
  options.my.profiles.llm.mid = lib.mkEnableOption "Mid LLM preset profile";
  config.my.modules.misc.llm = lib.mkIf cfg {
    enable = true;
    defaultModel = "phi2";
  };
}
