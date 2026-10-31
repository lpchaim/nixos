{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.my.bars.dux-shell.enable) {
    programs.dank-material-shell.settings.barConfigs = [
      {
        autoHide = false;
        autoHideDelay = 250;
        barLengthMode = "full";
        borderColor = "surfaceText";
        borderEnabled = false;
        borderOpacity = 1;
        borderThickness = 1;
        bottomGap = 0;
        centerWidgets = [
          {
            dwlShowAllTags = false;
            enabled = true;
            groupWorkspaceApps = true;
            id = "workspaceSwitcher";
            maxWorkspaceIcons = 5;
            reverseScrolling = false;
            showOccupiedWorkspacesOnly = true;
            showSpecialWorkspaces = false;
            showWorkspaceApps = true;
            showWorkspaceIndex = true;
            showWorkspaceName = false;
            showWorkspacePadding = false;
            workspaceAppIconSizeOffset = 0;
            workspaceColorMode = "default";
            workspaceFocusedBorderColor = "primary";
            workspaceFocusedBorderEnabled = false;
            workspaceFocusedBorderThickness = 2;
            workspaceFollowFocus = false;
            workspaceIndicatorCompact = true;
            workspaceIndicatorRoundness = -1;
            workspaceIndicatorStyle = "pills";
            workspaceUnfocusedColorMode = "default";
            workspaceUrgentColorMode = "default";
          }
        ];
        dot = false;
        enabled = true;
        followInterfaceStyle = true;
        fontScale = 1;
        gothCornerRadiusOverride = false;
        gothCornerRadiusValue = 12;
        gothCornersEnabled = false;
        hoverPopouts = false;
        iconScale = 1;
        id = "default";
        innerPadding = 2;
        island = false;
        islandAlongOffset = 0;
        islandFloating = false;
        islandHighContrast = false;
        islandHomeCompactTight = false;
        islandHomeLayout = [
          {
            enabled = false;
            id = "workspaces";
          }
          {
            enabled = true;
            id = "media";
          }
          {
            enabled = true;
            id = "clock";
          }
          {
            enabled = false;
            id = "weather";
          }
          {
            enabled = false;
            id = "status";
          }
          {
            enabled = false;
            id = "volume";
          }
          {
            enabled = false;
            id = "brightness";
          }
          {
            enabled = true;
            id = "notifications";
          }
          {
            enabled = true;
            id = "privacy";
          }
          {
            enabled = false;
            id = "tray";
          }
        ];
        islandInteractionMode = "hybrid";
        islandMediaClockVisible = true;
        islandNotch = false;
        islandNotificationExpand = false;
        islandOuterGap = 4;
        islandPalette = "default";
        islandPlacement = "edge";
        islandReserveThickness = 40;
        islandRouteControlCenter = "follow";
        islandRouteLauncher = "follow";
        islandSatelliteBackground = false;
        islandSatelliteGothCorners = false;
        islandSatellitePosition = "edges";
        islandSatellitesEnabled = true;
        islandSharedRouting = "normal";
        leftWidgets = [
          {
            clockCompactMode = false;
            enabled = true;
            id = "clock";
          }
          {
            enabled = true;
            id = "weather";
          }
          {
            enabled = true;
            focusedWindowCompactMode = true;
            focusedWindowShowIcon = true;
            focusedWindowSize = 1;
            id = "focusedWindow";
            overflowMode = "section";
          }
        ];
        maximizeDetection = false;
        maximizeWidgetIcons = false;
        maximizeWidgetText = false;
        name = "Main Bar";
        noBackground = false;
        openOnOverview = false;
        popupGapsAuto = true;
        popupGapsManual = 4;
        position = 0;
        rightWidgets = [
          {
            enabled = true;
            id = "privacyIndicator";
            privacyShowCameraIcon = false;
            privacyShowMicIcon = false;
            privacyShowScreenShareIcon = false;
          }
          {
            audioScrollMode = "volume";
            enabled = true;
            id = "music";
            mediaSize = 1;
          }
          {
            enabled = true;
            id = "systemTray";
          }
          {
            enabled = true;
            id = "cpuUsage";
            minimumWidth = true;
            overflowMode = "section";
          }
          {
            enabled = true;
            id = "clipboard";
          }
          {
            enabled = true;
            id = "notificationButton";
          }
          {
            enabled = true;
            id = "battery";
          }
          {
            enabled = true;
            id = "keyboard_layout_name";
            keyboardLayoutNameCompactMode = true;
            keyboardLayoutNameLabelOverrides = {
              br-nodeadkeys = "br";
              us-altgr-intl = "us";
            };
            keyboardLayoutNameShowIcon = true;
            overflowMode = "section";
          }
          {
            enabled = true;
            id = "controlCenterButton";
            showAudioIcon = true;
            showAudioPercent = false;
            showBatteryIcon = false;
            showBluetoothIcon = true;
            showBrightnessIcon = false;
            showBrightnessPercent = false;
            showMicIcon = false;
            showMicPercent = true;
            showNetworkIcon = true;
            showPrinterIcon = false;
            showScreenSharingIcon = true;
            showVpnIcon = true;
          }
        ];
        screenPreferences = ["all"];
        shadowIntensity = 0;
        showOnLastDisplay = true;
        spacing = 5;
        squareCorners = false;
        transparency = 1;
        useOverlayLayer = false;
        visible = true;
        widgetFollowInterfaceStyle = true;
        widgetOutlineColor = "primary";
        widgetOutlineEnabled = false;
        widgetStyle = "pills";
        widgetTransparency = 1;
      }
      {
        autoHide = false;
        autoHideDelay = 250;
        borderColor = "surfaceText";
        borderEnabled = false;
        borderOpacity = 1;
        borderThickness = 1;
        bottomGap = 0;
        centerWidgets = [
          {
            dwlShowAllTags = false;
            enabled = true;
            groupWorkspaceApps = true;
            id = "workspaceSwitcher";
            maxWorkspaceIcons = 4;
            reverseScrolling = false;
            showOccupiedWorkspacesOnly = true;
            showWorkspaceApps = true;
            showWorkspaceIndex = true;
            showWorkspaceName = false;
            showWorkspacePadding = false;
            workspaceColorMode = "default";
            workspaceFocusedBorderColor = "primary";
            workspaceFocusedBorderEnabled = false;
            workspaceFocusedBorderThickness = 2;
            workspaceFollowFocus = false;
            workspaceUnfocusedColorMode = "default";
            workspaceUrgentColorMode = "default";
          }
        ];
        dot = true;
        enabled = false;
        followInterfaceStyle = false;
        fontScale = 1;
        gothCornerRadiusOverride = false;
        gothCornerRadiusValue = 12;
        gothCornersEnabled = false;
        hoverPopouts = false;
        id = "dot1793447103397";
        innerPadding = 5;
        island = false;
        islandNotch = false;
        islandRouteControlCenter = "follow";
        islandRouteLauncher = "follow";
        leftWidgets = [
          {
            clockCompactMode = false;
            enabled = true;
            id = "clock";
          }
          {
            enabled = true;
            id = "weather";
          }
          {
            enabled = true;
            focusedWindowCompactMode = false;
            focusedWindowShowIcon = true;
            focusedWindowSize = 1;
            id = "focusedWindow";
            overflowMode = "section";
          }
        ];
        maximizeDetection = false;
        name = "Dot";
        noBackground = false;
        openOnOverview = false;
        popupGapsAuto = true;
        popupGapsManual = 4;
        position = 0;
        rightWidgets = [
          {
            audioScrollMode = "volume";
            enabled = true;
            id = "music";
            mediaSize = 1;
          }
          {
            enabled = true;
            id = "systemTray";
          }
          {
            enabled = true;
            id = "cpuUsage";
            minimumWidth = true;
          }
          {
            enabled = true;
            id = "clipboard";
          }
          {
            enabled = true;
            id = "notificationButton";
          }
          {
            enabled = true;
            id = "battery";
          }
          {
            enabled = true;
            id = "controlCenterButton";
            showAudioIcon = true;
            showAudioPercent = false;
            showBatteryIcon = false;
            showBluetoothIcon = true;
            showBrightnessIcon = false;
            showBrightnessPercent = false;
            showMicIcon = false;
            showMicPercent = true;
            showNetworkIcon = true;
            showPrinterIcon = false;
            showScreenSharingIcon = true;
            showVpnIcon = true;
          }
        ];
        screenPreferences = ["all"];
        shadowIntensity = 0;
        showOnLastDisplay = true;
        spacing = 5;
        squareCorners = false;
        transparency = 1;
        useOverlayLayer = false;
        visible = true;
        widgetFollowInterfaceStyle = true;
        widgetOutlineColor = "primary";
        widgetOutlineEnabled = false;
        widgetTransparency = 1;
      }
    ];
  };
}
