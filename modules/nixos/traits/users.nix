# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

let
  userName = "lpchaim";
  fullName = "Lucas Chaim";
in
{
  users = {
    mutableUsers = false;
    groups.${userName} = {
      gid = 1000;
    };
    extraUsers = {
      ${userName} = {
        isNormalUser = true;
        home = "/home/${userName}";
        description = fullName;
        group = userName;
        extraGroups = [ "i2c" "networkmanager" "wheel" ];
        shell = pkgs.zsh;
        hashedPasswordFile = "${config.sops.secrets."password".path}";
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQAFO5gvPrZ5cgJXQKi+KbV+rxggF1vZLYy/wY+zpYFnHGwR2u+W3NWJOwniSI/DptwpMh6tOqEPZyJiNPWDQFnXASgszihMk+Rh+QePspo/W2EkxZb2SNUWkJbLV+OTZsAd+AnXDfcR9sM/OEpXgQc0e9ltVij46P2SM3MEkrjcwkfTwGplRoGeVEfTjTsk1BeH9GzWKztPFg1/W/YO8dN4LFvJB5h93o8OEgH6nFhybHSu0aELFyOIHolDxYTBgWgFE8nucuo4RbHYyFaPw+5X7JsnHsAdHFjsqnLSQGide1PmQ9rSghlEkK4VlfzZpui2kWf3R9/ijHtkC5V5bsMP8Ij/JrQtb4bOcyQwbo5fsO8jpc0pfTaV2m6J5SlF9I9V48kCM2Lfm1c3wmQrqqN+hmH93TDNm4DR+iyAxSxRoqw3gCB40/O1cGJr80gxH4OPDIfG9gpPjBwJXbQhbVUbLlC2lOLarBqh4jmscYKaal1B26gsCTmmVB+l5iz70= lpchaim@LPCHAIM-DESKTOP"
        ];
      };
      root.hashedPassword = null;
    };
  };
  nix.settings.trusted-users = [ "root" "@wheel" ];
  services.ollama.writablePaths = [ config.users.extraUsers.lpchaim.home ];
  jovian.steam.user = userName;
}
