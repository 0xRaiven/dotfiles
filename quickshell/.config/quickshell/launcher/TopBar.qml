import QtQuick
import "search"

Item {
    id: topBar

    property var colors
    property string activeMode: ""
    property bool iconsSeparated: false

    property alias searchText: searchBar.text
    property alias searchCursorPosition: searchBar.cursorPosition

    signal textChanged(string text)
    signal escapePressed()
    signal returnPressed()
    signal downPressed()
    signal upPressed()
    signal rightPressed()
    signal leftPressed()
    signal modeClicked(string mode)

    function forceActiveFocus() {
        searchBar.forceActiveFocus()
    }

    function triggerSeparation() {
        if (!iconsSeparated) {
            iconsSeparated = true
            separationTimer.stop()
            glowAnim.start()
            fluidSeparationAnim.start()
        }
    }

    // Snap icons to separated state without animation (for initial query)
    function snapSeparated() {
        iconsSeparated = true
        separationTimer.stop()
        searchBar.x = 0
        btnApps.visible = true; btnApps.x = 548; btnApps.opacity = 1.0; btnApps.scale = 1.0
        btnFiles.visible = true; btnFiles.x = 608; btnFiles.opacity = 1.0; btnFiles.scale = 1.0
        btnWallpapers.visible = true; btnWallpapers.x = 668; btnWallpapers.opacity = 1.0; btnWallpapers.scale = 1.0
        btnClipboard.visible = true; btnClipboard.x = 728; btnClipboard.opacity = 1.0; btnClipboard.scale = 1.0
    }

    height: 52

    Timer {
        id: separationTimer
        interval: 1000
        running: true
        repeat: false
        onTriggered: topBar.triggerSeparation()
    }

    // Search Capsule Pill
    SearchBar {
        id: searchBar
        x: 121
        width: 538
        colors: topBar.colors
        placeholderText: {
            if (topBar.activeMode === "clipboard") return "Search clipboard history..."
            if (topBar.activeMode === "wallpaper") return "Search wallpapers..."
            if (topBar.activeMode === "apps") return "Search applications..."
            if (topBar.activeMode === "files") return "Search files..."
            if (topBar.activeMode === "commands") return "Search commands & controls..."
            return "Search"
        }

        onTextChanged: function(text) { topBar.textChanged(text) }
        onEscapePressed: topBar.escapePressed()
        onReturnPressed: topBar.returnPressed()
        onDownPressed: topBar.downPressed()
        onUpPressed: topBar.upPressed()
        onRightPressed: topBar.rightPressed()
        onLeftPressed: topBar.leftPressed()
    }

    // Fluid Separation Glow Pulse
    Rectangle {
        id: separationGlow
        x: searchBar.x + searchBar.width - 26
        y: 0
        width: 52
        height: 52
        radius: 26
        color: colors.primary
        opacity: 0

        ParallelAnimation {
            id: glowAnim
            SequentialAnimation {
                NumberAnimation { target: separationGlow; property: "opacity"; to: 0.35; duration: 80 }
                NumberAnimation { target: separationGlow; property: "opacity"; to: 0; duration: 320; easing.type: Easing.OutCubic }
            }
            NumberAnimation { target: separationGlow; property: "scale"; from: 0.6; to: 1.4; duration: 400; easing.type: Easing.OutCubic }
        }
    }

    // Fluid Separation Animation
    ParallelAnimation {
        id: fluidSeparationAnim

        NumberAnimation {
            target: searchBar
            property: "x"
            from: 121
            to: 0
            duration: 440
            easing.type: Easing.OutCubic
        }

        // Apps droplet (0ms stagger)
        SequentialAnimation {
            PropertyAction { target: btnApps; property: "visible"; value: true }
            ParallelAnimation {
                NumberAnimation { target: btnApps; property: "x"; from: 510; to: 548; duration: 420; easing.type: Easing.OutBack; easing.overshoot: 1.28 }
                NumberAnimation { target: btnApps; property: "scale"; from: 0.2; to: 1.0; duration: 380; easing.type: Easing.OutBack; easing.overshoot: 1.30 }
                NumberAnimation { target: btnApps; property: "opacity"; from: 0.0; to: 1.0; duration: 220; easing.type: Easing.OutCubic }
            }
        }

        // Files droplet (50ms stagger)
        SequentialAnimation {
            PauseAnimation { duration: 50 }
            PropertyAction { target: btnFiles; property: "visible"; value: true }
            ParallelAnimation {
                NumberAnimation { target: btnFiles; property: "x"; from: 530; to: 608; duration: 440; easing.type: Easing.OutBack; easing.overshoot: 1.28 }
                NumberAnimation { target: btnFiles; property: "scale"; from: 0.2; to: 1.0; duration: 400; easing.type: Easing.OutBack; easing.overshoot: 1.30 }
                NumberAnimation { target: btnFiles; property: "opacity"; from: 0.0; to: 1.0; duration: 240; easing.type: Easing.OutCubic }
            }
        }

        // Wallpapers droplet (100ms stagger)
        SequentialAnimation {
            PauseAnimation { duration: 100 }
            PropertyAction { target: btnWallpapers; property: "visible"; value: true }
            ParallelAnimation {
                NumberAnimation { target: btnWallpapers; property: "x"; from: 550; to: 668; duration: 460; easing.type: Easing.OutBack; easing.overshoot: 1.28 }
                NumberAnimation { target: btnWallpapers; property: "scale"; from: 0.2; to: 1.0; duration: 420; easing.type: Easing.OutBack; easing.overshoot: 1.30 }
                NumberAnimation { target: btnWallpapers; property: "opacity"; from: 0.0; to: 1.0; duration: 260; easing.type: Easing.OutCubic }
            }
        }

        // Clipboard droplet (150ms stagger)
        SequentialAnimation {
            PauseAnimation { duration: 150 }
            PropertyAction { target: btnClipboard; property: "visible"; value: true }
            ParallelAnimation {
                NumberAnimation { target: btnClipboard; property: "x"; from: 570; to: 728; duration: 480; easing.type: Easing.OutBack; easing.overshoot: 1.28 }
                NumberAnimation { target: btnClipboard; property: "scale"; from: 0.2; to: 1.0; duration: 440; easing.type: Easing.OutBack; easing.overshoot: 1.30 }
                NumberAnimation { target: btnClipboard; property: "opacity"; from: 0.0; to: 1.0; duration: 280; easing.type: Easing.OutCubic }
            }
        }
    }

    // === Mode Buttons ===

    ModeButton {
        id: btnApps
        x: 548; y: 0
        visible: false; opacity: 0.0; scale: 0.0
        colors: topBar.colors
        mode: "apps"
        activeMode: topBar.activeMode
        iconText: ""
        svgPath: "M 10.97 4.14 L 11.49 3.21 C 11.84 2.63 12.54 2.46 13.12 2.81 C 13.7 3.1 13.88 3.85 13.53 4.43 L 8.47 13.21 L 12.13 13.21 C 13.35 13.21 13.99 14.6 13.47 15.59 L 2.72 15.59 C 2.08 15.59 1.5 15.07 1.5 14.43 C 1.5 13.73 2.08 13.21 2.72 13.21 L 5.74 13.21 L 9.58 6.53 L 8.41 4.43 C 8.07 3.85 8.24 3.1 8.82 2.81 C 9.4 2.46 10.1 2.63 10.45 3.21 L 10.97 4.14 Z M 6.38 16.81 L 5.28 18.79 C 4.93 19.37 4.23 19.54 3.65 19.19 C 3.07 18.9 2.89 18.15 3.19 17.62 L 4.06 16.11 C 4.99 15.82 5.8 16.06 6.38 16.81 Z M 16.2 13.21 L 19.28 13.21 C 19.98 13.21 20.5 13.73 20.5 14.43 C 20.5 15.07 19.98 15.59 19.28 15.59 L 17.59 15.59 L 18.76 17.62 C 19.05 18.15 18.87 18.9 18.29 19.19 C 17.71 19.54 17.01 19.37 16.67 18.79 C 14.75 15.42 13.3 12.86 12.31 11.17 C 11.32 9.49 12.02 7.75 12.71 7.17 C 13.47 8.5 14.63 10.54 16.2 13.21 Z"
        onClicked: topBar.modeClicked("apps")
    }

    ModeButton {
        id: btnFiles
        x: 608; y: 0
        visible: false; opacity: 0.0; scale: 0.0
        colors: topBar.colors
        mode: "files"
        activeMode: topBar.activeMode
        iconText: "󰉋"
        onClicked: topBar.modeClicked("files")
    }

    ModeButton {
        id: btnWallpapers
        x: 668; y: 0
        visible: false; opacity: 0.0; scale: 0.0
        colors: topBar.colors
        mode: "wallpaper"
        activeMode: topBar.activeMode
        iconText: "󰧾"
        onClicked: topBar.modeClicked("wallpaper")
    }

    ModeButton {
        id: btnClipboard
        x: 728; y: 0
        visible: false; opacity: 0.0; scale: 0.0
        colors: topBar.colors
        mode: "clipboard"
        activeMode: topBar.activeMode
        iconText: "󰆏"
        onClicked: topBar.modeClicked("clipboard")
    }
}
