# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs
, system
, inputs
, lib
, ...
}:

{
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    allowSFTP = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # Programs
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    inputs.nix-software-center.packages.${system}.nix-software-center
    snowfallorg.flake
    vim
    wget
    winetricks
    wineWowPackages.stable
  ];
  environment.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  # Package manager
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = flakes nix-command
    '';
    settings = {
      keep-outputs = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://snowflakeos.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "snowflakeos.cachix.org-1:gXb32BL86r9bw1kBiw9AJuIkqN49xBvPd1ZW8YlqO70="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };
  nixpkgs.config.allowUnfree = true;

  # Networking
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    57621 # spotify local discovery
    5353 # spotify cast discovery
  ];
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  # Internationalization
  time = {
    timeZone = "America/Sao_Paulo";
    hardwareClockInLocalTime = true;
  };
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "pt_BR.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true; # use xkb.options in tty.
  services.xserver.xkb = {
    layout = "br,br,us";
    variant = ",nodeadkeys,intl";
  };

  # Graphics
  hardware = {
    opengl =
      let
        getExtraPackages = p: with p; [
          intel-media-driver
          intel-vaapi-driver
        ];
      in
      {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = getExtraPackages pkgs;
        extraPackages32 = getExtraPackages pkgs.pkgsi686Linux;
      };
  };

  # Bluetooth tweaks
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        FastConnectable = true;
      };
    };
  };
  services.blueman.enable = true;

  # Boot
  boot = {
    initrd.systemd.enable = true;
    plymouth = {
      enable = true;
      theme = lib.mkDefault "breeze";
    };
    kernelParams = [ "splash" "quiet" "btusb.enable_autosuspend=n" ];
  };

  # Secrets
  sops = {
    defaultSopsFile = ../../secrets/default.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      password.neededForUsers = true;
    };
  };

  # Theming
  stylix = {
    image = ../../assets/wallpaper-city-d.png;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    fonts.monospace = {
      name = "JetBrainsMono";
      package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
    };
    homeManagerIntegration = {
      autoImport = false;
      followSystem = true;
    };
  };
}
