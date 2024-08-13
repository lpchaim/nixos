{ config, lib, pkgs, ... }:

lib.lpchaim.mkModule {
  inherit config;
  namespace = "my.security";
  options = {
    enable = lib.mkEnableOption "security settings" // { default = true; };
    u2f = {
      control = lib.mkOption {
        description = "See pam.conf(5)";
        default = "sufficient";
      };
      login.control = lib.mkOption {
        description = "Specific to login";
        default = "required";
      };
    };
  };
  configBuilder = cfg: lib.mkIf cfg.enable {
    environment.etc."pam.d/login".text =
      let
        patchedLoginPam = lib.replaceStrings
          [ "auth ${cfg.u2f.control} ${pkgs.pam_u2f}" ]
          [ "auth ${cfg.u2f.login.control} ${pkgs.pam_u2f}" ]
          config.security.pam.services.login.text;
      in
      lib.mkForce patchedLoginPam;
    security.pam = {
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
      sshAgentAuth.enable = true;
      u2f = {
        inherit (cfg.u2f) control;
        enable = true;
        settings.authfile = "${config.sops.secrets."u2f-mappings".path}";
        settings.cue = true;
      };
    };
    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
    services = {
      pcscd.enable = true;
      udev = {
        extraRules = ''
          ACTION=="remove", \
          ENV{ID_BUS}=="usb", \
          ENV{ID_MODEL_ID}=="0407", \
          ENV{ID_VENDOR_ID}=="1050", \
          ENV{ID_VENDOR}=="Yubico", \
          RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
        '';
        packages = [ pkgs.yubikey-personalization ];
      };
    };
    environment.systemPackages = with pkgs; [
      gnupg
      pam_u2f
      pamtester
      yubikey-personalization
      yubioath-flutter
    ];
  };
}
