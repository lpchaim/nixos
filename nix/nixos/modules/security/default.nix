{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  cfg = config.my.security;
in {
  options.my.security = {
    enable = lib.mkEnableOption "security settings";
    u2f = {
      control = lib.mkOption {
        inherit (options.security.pam.u2f.control) description type;
        default = "sufficient";
      };
      relaxed = lib.mkOption {
        description = "Relax required to sufficient for less critical devices";
        type = lib.types.bool;
        default = false;
      };
      screenOffOnUnplug = lib.mkOption {
        description = "Turn screen off on dongle removal";
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    environment.etc = let
      patch = svc:
        lib.replaceStrings
        ["auth ${cfg.u2f.control} ${pkgs.pam_u2f}"]
        ["auth sufficient ${pkgs.pam_u2f}"]
        config.security.pam.services.${svc}.text;
      needsPatch = cfg.u2f.control != "sufficient";
      patchIfNeeded = svc:
        lib.mkIf (cfg.u2f.relaxed && needsPatch) (lib.mkForce (patch svc));
    in {
      "pam.d/login".text = patchIfNeeded "login";
      "pam.d/sudo".text = patchIfNeeded "sudo";
    };
    security.pam = {
      services = {
        login.u2fAuth = false;
        sshd.u2fAuth = true;
        sudo.u2fAuth = true;
      };
      sshAgentAuth.enable = true;
      u2f = {
        inherit (cfg.u2f) control;
        enable = true;
        settings.authfile = "${config.sops.secrets."u2f-mappings".path}";
        settings = {
          cue = true;
          appid = "pam://auth";
          origin = "pam://localhost";
        };
      };
    };
    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
    services = {
      udev = {
        extraRules = lib.mkIf cfg.u2f.screenOffOnUnplug ''
          ACTION=="remove", \
          ENV{ID_BUS}=="usb", \
          ENV{ID_MODEL_ID}=="0407", \
          ENV{ID_VENDOR_ID}=="1050", \
          ENV{ID_VENDOR}=="Yubico", \
          RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
        '';
        packages = [pkgs.yubikey-personalization];
      };
    };
    environment.systemPackages =
      (with pkgs; [
        gnupg
        pam_u2f
        pamtester
        yubikey-personalization
      ])
      ++ lib.optionals config.my.profiles.graphical [
        pkgs.yubioath-flutter
      ];
    sops.secrets.u2f-mappings = {
      group = "wheel";
      mode = "0440";
    };
  };
}
