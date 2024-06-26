# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config
, inputs
, lib
, pkgs
, system
, ...
}:

let
  inherit (lib) mkDefault;
  getFileSystemsByFsType = fsType:
    lib.filterAttrs (_: fs: fs.fsType == fsType) config.fileSystems;
in
{
  imports = [
    ../../shared
  ];

  # Boot
  boot = {
    loader = {
      grub = {
        enable = mkDefault true;
        device = "nodev";
        efiSupport = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false;
    };
    initrd.systemd.enable = true;
    plymouth = {
      enable = true;
      theme = mkDefault "breeze";
    };
    kernelParams = [ "splash" "quiet" "btusb.enable_autosuspend=n" ];
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
        "https://nyx.chaotic.cx"
        "https://snowflakeos.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
        "snowflakeos.cachix.org-1:gXb32BL86r9bw1kBiw9AJuIkqN49xBvPd1ZW8YlqO70="
      ];
    };
    gc = {
      automatic = true;
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
    dhcpcd.extraConfig =
      let wifiOffset = 2000;
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
    layout = "br,br,us";
    variant = ",nodeadkeys,intl";
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
    graphics =
      let
        getExtraPackages = p: with p; [
          intel-media-driver
          intel-vaapi-driver
        ];
      in
      {
        enable = true;
        enable32Bit = true;
        extraPackages = getExtraPackages pkgs;
        extraPackages32 = getExtraPackages pkgs.pkgsi686Linux;
      };
  };

  # Programs
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    helix
    inputs.nix-software-center.packages.${system}.nix-software-center
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
    btrfs.autoScrub =
      let
        btrfsFileSystems = getFileSystemsByFsType "btrfs";
      in
      lib.mkIf (btrfsFileSystems != { }) {
        enable = true;
        interval = "monthly";
        fileSystems =
          if btrfsFileSystems?"/"
          then [ "/" ]
          else lib.attrNames btrfsFileSystems;
      };
    fstrim = {
      enable = true;
      interval = "weekly";
    };
    libinput.enable = true;
    ollama = {
      enable = true;
      # openFirewall = true;
      host = "127.0.0.1";
      port = 11434;
      sandbox = true;
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
    printing.enable = true;
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
  };
  services.xserver.enable = true;

  # Misc
  home-manager = {
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  sops = {
    defaultSopsFile = lib.snowfall.fs.get-file "secrets/default.yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      password.neededForUsers = true;
    };
  };
  sound.enable = true;
  stylix = {
    homeManagerIntegration = {
      autoImport = false;
      followSystem = true;
    };
    targets.plymouth.enable = false;
  };
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
