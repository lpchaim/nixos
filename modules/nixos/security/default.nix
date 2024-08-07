{ pkgs, ... }:

{
  security.pam = {
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
    sshAgentAuth.enable = true;
    u2f = {
      enable = true;
      control = "sufficient";
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
    yubikey-personalization
    yubioath-flutter
  ];
}
