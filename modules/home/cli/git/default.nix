{ config, lib, ... }:

let
  namespace = [ "my" "modules" "cli" "git" ];
  cfg = lib.getAttrFromPath namespace config;
in
{
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
        userEmail = "lpchaim@gmail.com";
        userName = "Lucas Chaim";
      };
      lazygit.enable = lib.mkIf cfg.lazygit.enable true;
    };
  };
}
