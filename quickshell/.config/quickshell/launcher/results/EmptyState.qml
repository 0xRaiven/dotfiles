import QtQuick

Item {
    id: emptyState

    property var colors
    property string activeMode: "search"
    property bool wallpaperLoaderRunning: false
    property bool clipboardLoaderRunning: false

    Text {
        anchors.centerIn: parent
        text: emptyState.activeMode === "wallpaper"
            ? (emptyState.wallpaperLoaderRunning ? "Loading wallpapers..." : "No wallpapers found")
            : (emptyState.activeMode === "clipboard"
                ? (emptyState.clipboardLoaderRunning ? "Loading clipboard history..." : "Clipboard history is empty")
                : "No results found")
        color: colors.muted
        font.pixelSize: 14
    }
}
