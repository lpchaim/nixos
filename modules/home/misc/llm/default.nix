{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.home-manager.lib) hm;
  inherit (inputs.nix-std.lib) serde;
  inherit (lib) mkIf mkEnableOption mkOption;
  namespace = ["my" "modules" "misc" "llm"];
  cfg = lib.getAttrFromPath namespace config;
  defaultEnable = {default = cfg.enable;};
in {
  options = lib.setAttrByPath namespace {
    enable = mkEnableOption "LLM tools";
    defaultModel = mkOption {
      description = "Which model to use by default";
      type = lib.types.str;
      default = "tinyllama";
    };
    ollama = {
      enable = mkEnableOption "ollama configuration" // defaultEnable;
      url = mkOption {
        description = "The URL of the ollama server";
        type = lib.types.str;
        default = "http://localhost:11434";
      };
      model = mkOption {
        description = "Which model to use";
        type = lib.types.str;
        default = cfg.defaultModel;
      };
    };
    smartcat = {
      enable = mkEnableOption "smartcat" // defaultEnable;
      model = mkOption {
        description = "Which model to use";
        type = lib.types.str;
        default = cfg.defaultModel;
      };
    };
  };
  config = mkIf cfg.enable (lib.mkMerge [
    (mkIf cfg.ollama.enable {
      home.activation.setupOllamaModels = let
        models = lib.lists.unique [
          cfg.defaultModel
          cfg.ollama.model
          cfg.smartcat.model
        ];
      in
        hm.dag.entryAfter ["writeBoundary"] ''
          run echo "${lib.concatStringsSep "\n" models}" \
          | ${pkgs.parallel}/bin/parallel ${pkgs.ollama}/bin/ollama pull {}
        '';
    })
    (mkIf cfg.smartcat.enable {
      home = {
        packages = [pkgs.lpchaim.smartcat];
        file = {
          ".config/smartcat/.api_config.toml".text = serde.toTOML {
            ollama = {
              url = "${cfg.ollama.url}/api/chat";
              default_model = cfg.smartcat.model;
              timeout = 0;
            };
          };
          ".config/smartcat/prompts.toml".text = serde.toTOML {
            default = {
              api = "ollama";
              model = cfg.smartcat.model;
              messages = [
                {
                  role = "system";
                  content = "
                  You are an extremely skilled programmer with a keen eye for detail and an emphasis on readable code.
                  You have been tasked with acting as a smart version of the cat unix program. You take text and a prompt in and write text out.
                  For that reason, it is of crucial importance to just write the desired output. Do not under any circumstance write any comment or thought
                  as you output will be piped into other programs. Do not write the markdown delimiters for code as well.
                  Sometimes you will be asked to implement or extend some input code. Same thing goes here, write only what was asked because what you write will
                  be directly added to the user's editor. Never ever write ``` around the code.
                ";
                }
              ];
            };
            test = {
              api = "ollama";
              messages = [
                {
                  role = "system";
                  content = "
                  You are an extremely skilled programmer with a keen eye for detail and an emphasis on readable code.
                  You have been tasked with acting as a smart version of the cat unix program. You take text and a prompt in and write text out.
                  For that reason, it is of crucial importance to just write the desired output. Do not under any circumstance write any comment or thought
                  as you output will be piped into other programs. Do not write the markdown delimiters for code as well.
                  Sometimes you will be asked to implement or extend some input code. Same thing goes here, write only what was asked because what you write will
                  be directly added to the user's editor.
                  Never ever write ``` around the code.
                ";
                }
              ];
            };
            empty = {
              api = "ollama";
              messages = [];
            };
          };
        };
      };
    })
  ]);
}
