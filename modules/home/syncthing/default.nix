{
  lib,
  pkgs,
  ...
} @ args: let
  # inherit (inputs.home-manager.lib) hm;
  inherit (pkgs) syncthingtray;
  syncthing = args.osConfig.services.syncthing.package;
in
  lib.mkIf (args ? osConfig && args.osConfig.services.syncthing.enable) {
    home.packages = [pkgs.syncthingtray];
    services.syncthing.tray.enable = true;
    systemd.user.services.syncthingtray = {
      Service.ExecStart = lib.mkForce (pkgs.writeShellScript "syncthingtray-wait" ''
        ${pkgs.syncthingtray}/bin/syncthingtray --wait
      '');
      Service.ExecStartPre = pkgs.writeShellScript "setup-syncthingtray" ''
          cat <<EOF >> ~/.config/syncthingtray.ini
          [General]
          v=${pkgs.syncthingtray.version}

          [startup]
          considerForReconnect=false
          considerLauncherForReconnect=false
          showButton=false
          showLauncherButton=false
          stopOnMetered=false
          stopServiceOnMetered=false
          syncthingArgs="serve --no-browser --logflags=3"
          syncthingAutostart=false
          syncthingPath=syncthing
          syncthingUnit=syncthing.service
          systemUnit=false
          useLibSyncthing=false

          [tray]
          connections\1\apiKey=@ByteArray($(${syncthing}/bin/syncthing cli config dump-json | nu --stdin --commands 'from json | get gui.apiKey'))
          connections\1\authEnabled=false
          connections\1\autoConnect=true
          connections\1\devStatsPollInterval=60000
          connections\1\diskEventLimit=200
          connections\1\errorsPollInterval=30000
          connections\1\httpsCertPath=/home/lpchaim/.config/syncthing/https-cert.pem
          connections\1\label=Primary instance
          connections\1\longPollingTimeout=0
          connections\1\password=
          connections\1\pauseOnMetered=false
          connections\1\reconnectInterval=30000
          connections\1\requestTimeout=0
          connections\1\statusComputionFlags=59
          connections\1\syncthingUrl=http://127.0.0.1:8384
          connections\1\trafficPollInterval=5000
          connections\1\userName=
          connections\size=1
          dbusNotifications=true
          distinguishTrayIcons=false
          frameStyle=16
          ignoreInavailabilityAfterStart=15
          notifyOnDisconnect=true
          notifyOnErrors=true
          notifyOnLauncherErrors=true
          notifyOnLocalSyncComplete=false
          notifyOnNewDeviceConnects=false
          notifyOnNewDirectoryShared=false
          notifyOnRemoteSyncComplete=false
          positioning\assumedIconPos=@Point(0 0)
          positioning\useAssumedIconPosition=false
          positioning\useCursorPos=true
          preferIconsFromTheme=false
          showSyncthingNotifications=true
          showTabTexts=true
          showTraffic=true
          statusIcons="#ff26b6db,#ff0882c8,#ffffffff;#ffdb3c26,#ffc80828,#ffffffff;#ffc9ce3b,#ffebb83b,#ffffffff;#ff2d9d69,#ff2d9d69,#ffffffff;#ff26b6db,#ff0882c8,#ffffffff;#ff26b6db,#ff0882c8,#ffffffff;#ffa9a9a9,#ff58656c,#ffffffff;#ffa9a9a9,#ff58656c,#ffffffff"
          statusIconsRenderSize=@Size(32 32)
          statusIconsStrokeWidth=0
          tabPos=1
          trayIcons="#ff26b6db,#ff0882c8,#ffffffff;#ffdb3c26,#ffc80828,#ffffffff;#ffc9ce3b,#ffebb83b,#ffffffff;#ff2d9d69,#ff2d9d69,#ffffffff;#ff26b6db,#ff0882c8,#ffffffff;#ff26b6db,#ff0882c8,#ffffffff;#ffa9a9a9,#ff58656c,#ffffffff;#ffa9a9a9,#ff58656c,#ffffffff"
          trayIconsRenderSize=@Size(32 32)
          trayIconsStrokeWidth=0
          trayMenuSize=@Size(575 475)
          usePaletteForStatusIcons=false
          usePaletteForTrayIcons=false
          windowType=0

          [webview]
          customCommand=
          disabled=false
          mode=0
          qt\customfont=false
          qt\customicontheme=false
          qt\customlocale=false
          qt\custompalette=false
          qt\customstylesheet=false
          qt\customwidgetstyle=false
          qt\font="Sans Serif,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
          qt\icontheme=hicolor
          qt\iconthemepath=
          qt\locale=en_US
          qt\palette=@Variant(\0\0\0\x44\x1\x1\xff\xff\0\0\0\0\0\0\0\0\x1\x1\xff\xff\xef\xef\xef\xef\xef\xef\0\0\x1\x1\xff\xff\xff\xff\xff\xff\xff\xff\0\0\x1\x1\xff\xff\xcb\x4\xcb\x4\xcb\x4\0\0\x1\x1\xff\xff\x9f\xf4\x9f\xf4\x9f\xf4\0\0\x1\x1\xff\xff\xb8\x90\xb8\x90\xb8\x90\0\0\x1\x1\xff\xff\0\0\0\0\0\0\0\0\x1\x1\xff\xff\xff\xff\xff\xff\xff\xff\0\0\x1\x1\xff\xff\0\0\0\0\0\0\0\0\x1\x1\xff\xff\xff\xff\xff\xff\xff\xff\0\0\x1\x1\xff\xff\xef\xef\xef\xef\xef\xef\0\0\x1\x1\xff\xffv{v{v{\0\0\x1\x1\xff\xff\x30\x30\x8c\x8c\xc6\xc6\0\0\x1\x1\xff\xff\xff\xff\xff\xff\xff\xff\0\0\x1\x1\xff\xff\0\0\0\0\xff\xff\0\0\x1\x1\xff\xff\xff\xff\0\0\xff\xff\0\0\x1\x1\xff\xff\xf7\xf7\xf7\xf7\xf7\xf7\0\0\x1\x1\xff\xff\xbe\xbe\xbe\xbe\xbe\xbe\0\0\x1\x1\xff\xff\xef\xef\xef\xef\xef\xef\0\0\x1\x1\xff\xff\xff\xff\xff\xff\xff\xff\0\0\x1\x1\xff\xff\xcb\x4\xcb\x4\xcb\x4\0\0\x1\x1\xff\xff\xbe\xbe\xbe\xbe\xbe\xbe\0\0\x1\x1\xff\xff\xb8\x90\xb8\x90\xb8\x90\0\0\x1\x1\xff\xff\xbe\xbe\xbe\xbe\xbe\xbe\0\0\x1\x1\xff\xff\xff\xff\xff\xff\xff\xff\0\0\x1\x1\xff\xff\xbe\xbe\xbe\xbe\xbe\xbe\0\0\x1\x1\xff\xff\xef\xef\xef\xef\xef\xef\0\0\x1\x1\xff\xff\xef\xef\xef\xef\xef\xef\0\0\x1\x1\xff\xff\xb1\xb8\xb1\xb8\xb1\xb8\0\0\x1\x1\xff\xff\x91\x91\x91\x91\x91\x91\0\0\x1\x1\xff\xff\xff\xff\xff\xff\xff\xff\0\0\x1\x1\xff\xff\0\0\0\0\xff\xff\0\0\x1\x1\xff\xff\xff\xff\0\0\xff\xff\0\0\x1\x1\xff\xff\xf7\xf7\xf7\xf7\xf7\xf7\0\0\x1\x1\xff\xff\0\0\0\0\0\0\0\0\x1\x1\xff\xff\xef\xef\xef\xef\xef\xef\0\0\x1\x1\xff\xff\xff\xff\xff\xff\xff\xff\0\0\x1\x1\xff\xff\xcb\x4\xcb\x4\xcb\x4\0\0\x1\x1\xff\xff\x9f\xf4\x9f\xf4\x9f\xf4\0\0\x1\x1\xff\xff\xb8\x90\xb8\x90\xb8\x90\0\0\x1\x1\xff\xff\0\0\0\0\0\0\0\0\x1\x1\xff\xff\xff\xff\xff\xff\xff\xff\0\0\x1\x1\xff\xff\0\0\0\0\0\0\0\0\x1\x1\xff\xff\xff\xff\xff\xff\xff\xff\0\0\x1\x1\xff\xff\xef\xef\xef\xef\xef\xef\0\0\x1\x1\xff\xffv{v{v{\0\0\x1\x1\xff\xff\x30\x30\x8c\x8c\xc6\xc6\0\0\x1\x1\xff\xff\xff\xff\xff\xff\xff\xff\0\0\x1\x1\xff\xff\0\0\0\0\xff\xff\0\0\x1\x1\xff\xff\xff\xff\0\0\xff\xff\0\0\x1\x1\xff\xff\xf7\xf7\xf7\xf7\xf7\xf7\0\0)
          qt\plugindir=
          qt\stylesheetpath=
          qt\trpath=
          qt\widgetstyle=
        EOF
      '';
      Unit.X-Restart-Triggers = [
        syncthing
        syncthingtray
        "syncthing.systemunit.service"
        "syncthing-init.systemunit.service"
        "syncthing-relay.systemunit.service"
      ];
      Unit.X-SwitchMethod = "restart";
    };
  }
