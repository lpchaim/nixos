{inputs, ...}: {
  time = {
    timeZone = "America/Sao_Paulo";
    hardwareClockInLocalTime = true;
  };
  i18n = {
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "pt_BR.UTF-8/UTF-8"
    ];
    defaultLocale = "en_US.UTF-8";
  };
  console.useXkbConfig = true; # use xkb.options in tty.
  services.xserver.xkb = {
    inherit (inputs.self.lib.config.kb.default) layout options variant;
  };
}
