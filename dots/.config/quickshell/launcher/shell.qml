import QtQuick
import Quickshell
import Quickshell.Wayland
import "search"

PanelWindow {
    id: root

    visible: true
    implicitWidth: 1920
    implicitHeight: 1080
    color: "transparent"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    Colors { id: colors }

    SearchEngine { id: engine }

    // === Computed state ===

    property bool resultsVisible: topBar.searchText.trim().length > 0
        || engine.calculation.length > 0 || engine.isDualPane
        || engine.isWallpaperMode || engine.activeMode === "apps"
        || engine.activeMode === "files"

    // === Functions ===

    function closeAndQuit() {
        root.visible = false
        Qt.quit()
    }

    function toggleMode(targetMode) {
        topBar.triggerSeparation()
        if (engine.activeMode === targetMode) {
            engine.activeMode = "search"
            if (topBar.searchText.startsWith("@") || topBar.searchText.startsWith(":")) {
                topBar.searchText = ""
            }
        } else {
            engine.activeMode = targetMode
            if (targetMode === "wallpaper") {
                topBar.searchText = "@"
                topBar.searchCursorPosition = 1
                engine.startWallpaperLoader()
            } else if (targetMode === "clipboard") {
                topBar.searchText = ":"
                topBar.searchCursorPosition = 1
                engine.startClipboardLoader()
            } else {
                if (topBar.searchText.startsWith("@") || topBar.searchText.startsWith(":")) {
                    topBar.searchText = ""
                }
            }
        }
        resultsCard.currentIndex = engine.rebuild(topBar.searchText)
        topBar.forceActiveFocus()
    }

    function runCurrent() {
        if (engine.calculation.length > 0
                && (resultsCard.currentIndex < 0
                    || topBar.searchText.trim() === engine.calculation)) {
            try {
                Quickshell.execDetached(["sh", "-lc",
                    "printf '%s' '" + engine.calculation.replace(/'/g, "'\\''") + "' | wl-copy"])
            } catch (e) {
                console.log("copy failed", e)
            }
            closeAndQuit()
            return
        }

        if (resultsCard.currentIndex < 0
                || resultsCard.currentIndex >= engine.resultModel.count) {
            closeAndQuit()
            return
        }
        var item = engine.resultModel.get(resultsCard.currentIndex)
        if (!item) {
            closeAndQuit()
            return
        }

        if (item.id === "@" || item.kind === "wallpaper-picker"
                || item.name === "Wallpaper Picker") {
            toggleMode("wallpaper")
            return
        }

        try {
            if (item.kind === "run")
                Quickshell.execDetached(["sh", "-lc", item.name])
            else if (item.kind === "app")
                Quickshell.execDetached(["gtk-launch", item.id])
            else if (item.kind === "file")
                Quickshell.execDetached(["xdg-open", item.id])
            else if (item.kind === "command")
                Quickshell.execDetached(["sh", "-lc", item.id])
            else if (item.kind === "clipboard")
                Quickshell.execDetached(["sh", "-lc",
                    "$HOME/.config/quickshell/scripts/clipboard/clipboard-restore " + item.id])
            else if (item.kind === "wallpaper")
                Quickshell.execDetached(["sh", "-lc",
                    "$HOME/.config/quickshell/scripts/wallpaper/apply-wallpaper '" + item.id + "'"])
        } catch (e) {
            console.log("execDetached failed", e)
        }
        closeAndQuit()
    }

    // === Visual Tree ===

    // Fullscreen scrim: click outside to dismiss
    MouseArea {
        anchors.fill: parent
        onClicked: root.closeAndQuit()
    }

    // Main Floating Container
    Item {
        id: spotlightContainer
        width: 780
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Math.round(parent.height * 0.16)
        scale: 0.92
        opacity: 0
        y: -16

        Component.onCompleted: entrance.start()

        ParallelAnimation {
            id: entrance
            NumberAnimation { target: spotlightContainer; property: "opacity"; to: 1; duration: 200; easing.type: Easing.OutCubic }
            NumberAnimation { target: spotlightContainer; property: "scale"; to: 1; duration: 280; easing.type: Easing.OutBack; easing.overshoot: 1.15 }
            NumberAnimation { target: spotlightContainer; property: "y"; to: 0; duration: 280; easing.type: Easing.OutCubic }
        }

        TopBar {
            id: topBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            colors: colors
            activeMode: engine.activeMode

            onTextChanged: function(text) {
                topBar.triggerSeparation()
                if (text.startsWith(":") && engine.activeMode !== "clipboard") {
                    engine.startClipboardLoader()
                }
                if (text.startsWith("@") && engine.activeMode !== "wallpaper") {
                    engine.startWallpaperLoader()
                }
                resultsCard.currentIndex = engine.rebuild(text)
            }

            onEscapePressed: root.closeAndQuit()
            onReturnPressed: root.runCurrent()

            onDownPressed: {
                if (engine.isWallpaperMode)
                    resultsCard.incrementIndexWallpaper()
                else
                    resultsCard.incrementIndex()
            }

            onUpPressed: {
                if (engine.isWallpaperMode)
                    resultsCard.decrementIndexWallpaper()
                else
                    resultsCard.decrementIndex()
            }

            onRightPressed: {
                if (engine.isWallpaperMode)
                    resultsCard.incrementIndexByOne()
            }

            onLeftPressed: {
                if (engine.isWallpaperMode)
                    resultsCard.decrementIndexByOne()
            }

            onModeClicked: function(mode) { root.toggleMode(mode) }
        }

        ResultsCard {
            id: resultsCard
            anchors.top: topBar.bottom
            anchors.topMargin: 12
            anchors.left: parent.left
            anchors.right: parent.right
            colors: colors
            activeMode: engine.activeMode
            resultModel: engine.resultModel
            calculation: engine.calculation
            isWallpaperMode: engine.isWallpaperMode
            isClipboardMode: engine.isClipboardMode
            isDualPane: engine.isDualPane
            resultsVisible: root.resultsVisible
            clipboardLoaderRunning: engine.clipboardLoaderRunning
            wallpaperLoaderRunning: engine.wallpaperLoaderRunning

            onItemActivated: root.runCurrent()
        }
    }

    Component.onCompleted: {
        const initialQuery = Quickshell.env("LAUNCHER_INITIAL_QUERY")
        if (initialQuery && initialQuery.length > 0) {
            topBar.snapSeparated()
            topBar.searchText = initialQuery
            topBar.searchCursorPosition = initialQuery.length
            if (initialQuery.startsWith(":")) {
                engine.activeMode = "clipboard"
                engine.startClipboardLoader()
            } else if (initialQuery.startsWith("@")) {
                engine.activeMode = "wallpaper"
                engine.startWallpaperLoader()
            }
        }
        topBar.forceActiveFocus()
    }
}
