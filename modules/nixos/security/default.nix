{
  config,
  lib,
  options,
  pkgs,
  ...
}:
lib.lpchaim.mkModule {
  inherit config;
  namespace = "my.security";
  options = {
    enable = lib.mkEnableOption "security settings" // {default = true;};
    u2f = {
      control = lib.mkOption {
        inherit (options.security.pam.u2f.control) description type;
        default = "requisite";
      };
      relaxed = lib.mkOption {
        description = "Relax required to sufficient for less critical devices";
        type = lib.types.bool;
        default = false;
      };
    };
  };
  configBuilder = cfg:
    lib.mkIf cfg.enable {
      environment.etc = let
        patch = svc:
          lib.replaceStrings
          ["auth ${cfg.u2f.control} ${pkgs.pam_u2f}"]
          ["auth sufficient ${pkgs.pam_u2f}"]
          config.security.pam.services.${svc}.text;
      in {
        "pam.d/login".text = lib.mkIf cfg.u2f.relaxed (lib.mkForce (patch "login"));
        "pam.d/sudo".text = lib.mkForce (patch "sudo");
      };
      security.pam = {
        services = {
          login.u2fAuth = true;
          sshd.u2fAuth = false;
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
          extraRules = ''
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
      environment.systemPackages = with pkgs; [
        gnupg
        pam_u2f
        pamtester
        yubikey-personalization
        yubioath-flutter
      ];
      sops.secrets.u2f-mappings = {
        group = "wheel";
        mode = "0440";
      };
    };
}
