# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
  inherit (lib.lpchaim) shared;
  inherit (lib.snowfall) fs;
  getFileSystemsByFsType = fsType:
    lib.filterAttrs (_: fs: fs.fsType == fsType) config.fileSystems;
in {
  imports = [
    (fs.get-file "modules/shared")
  ];

  # Boot
  boot = {
    loader = {
      grub = {
        enable = mkDefault false;
        device = "nodev";
        efiSupport = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = mkDefault true;
        editor = false;
        configurationLimit = 5;
        memtest86.enable = pkgs.stdenv.isx86_64;
        netbootxyz.enable = true;
      };
    };
    initrd.systemd.enable = true;
    plymouth = {
      enable = true;
      theme = mkDefault "breeze";
    };
    kernelParams = ["splash" "quiet" "btusb.enable_autosuspend=n"];
  };

  # Package manager
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = flakes nix-command
    '';
    settings = shared.nix.settings;
    gc = {
      automatic = !config.programs.nh.clean.enable;
      dates = "weekly";
    };
  };

  # Networking
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        57621 # spotify local discovery
        5353 # spotify cast discovery
      ];
    };
    dhcpcd.extraConfig = let
      wifiOffset = 2000;
    in ''
      ssid Lpchaim5G
      metric ${toString (wifiOffset - 20)}

      ssid Lpchaim
      metric ${toString (wifiOffset - 10)}
    '';
  };

  # Internationalization
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
    inherit (lib.lpchaim.shared.kb.default) layout options variant;
  };

  # Hardware
  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {
          FastConnectable = true;
        };
      };
    };
    graphics = let
      getExtraPackages = p:
        with p;
          lib.optionals pkgs.stdenv.isx86_64 [
            intel-media-driver
            intel-vaapi-driver
          ];
    in {
      enable = lib.mkDefault false;
      enable32Bit = config.hardware.graphics.enable && pkgs.stdenv.isx86_64;
      extraPackages = lib.mkIf config.hardware.graphics.enable (getExtraPackages pkgs);
      extraPackages32 = lib.mkIf config.hardware.graphics.enable (getExtraPackages pkgs.pkgsi686Linux);
    };
  };

  # Programs
  programs = {
    adb.enable = true;
    fish.enable = true;
    nix-ld.enable = true;
    nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep 5";
      };
    };
    zsh.enable = true;
  };
  environment.systemPackages = with pkgs; [
    android-udev-rules
    helix
    sbctl
    snowfallorg.flake
    vim
    wget
  ];
  environment.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  # Services
  services = {
    blueman.enable = true;
    btrfs.autoScrub = let
      btrfsFileSystems = getFileSystemsByFsType "btrfs";
    in
      lib.mkIf (btrfsFileSystems != {}) {
        enable = true;
        interval = "monthly";
        fileSystems =
          if btrfsFileSystems ? "/"
          then ["/"]
          else lib.attrNames btrfsFileSystems;
      };
    devmon.enable = true;
    fstrim = {
      enable = true;
      interval = "weekly";
    };
    fwupd.enable = true;
    gvfs.enable = true;
    libinput.enable = true;
    ollama = {
      enable = true;
      openFirewall = true;
      host = "127.0.0.1";
      port = 11434;
    };
    openssh = {
      enable = true;
      allowSFTP = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = mkDefault false;
        PermitRootLogin = mkDefault "no";
      };
    };
    power-profiles-daemon.enable = true;
    printing.enable = true;
    tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets."tailscale/oauth/secret".path;
      extraUpFlags = [
        "--accept-dns"
        "--accept-routes"
        "--advertise-exit-node"
        "--advertise-tags=tag:nixos"
        "--reset" # Forces unspecified arguments to default values
        "--ssh"
      ];
      openFirewall = true;
      useRoutingFeatures = "both";
    };
    udisks2.enable = true;
  };
  services.xserver.enable = lib.mkDefault true;

  # Misc
  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  sops = {
    defaultSopsFile = lib.snowfall.fs.get-file "secrets/default.yaml";
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets = {
      password.neededForUsers = true;
      "tailscale/oauth/secret" = {};
    };
  };
  stylix = {
    homeManagerIntegration = {
      autoImport = false;
      followSystem = true;
    };
    targets.plymouth.enable = false;
  };
  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce [];
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce [];
  };
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
  jovian.steamos.useSteamOSConfig = lib.mkDefault false;
}
