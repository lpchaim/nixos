{
  config,
  lib,
  ...
}: let
  namespace = ["my" "modules" "cli" "git"];
  cfg = lib.getAttrFromPath namespace config;
  inherit (lib.lpchaim.shared) defaults;
in {
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "git";
    lazygit.enable = lib.mkEnableOption "lazygit";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        delta.enable = true;
        extraConfig = {
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
          pull.rebase = false;
        };
        userEmail = defaults.name.email;
        userName = defaults.name.full;
      };
      lazygit.enable = lib.mkIf cfg.lazygit.enable true;
    };
  };
}
