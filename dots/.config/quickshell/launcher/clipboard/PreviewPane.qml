import QtQuick

Item {
    id: previewPane

    property var colors
    property var currentItem: null
    property bool isClipboardMode: false
    property bool clipboardLoaderRunning: false

    // Empty state
    Text {
        visible: previewPane.currentItem === null
        anchors.centerIn: parent
        text: previewPane.clipboardLoaderRunning ? "Loading clipboard..." : "No clipboard items"
        color: colors.muted
        font.pixelSize: 13
    }

    // Image preview
    ClipboardImagePreview {
        visible: previewPane.isClipboardMode
            && previewPane.currentItem !== null
            && previewPane.currentItem.isImage
        anchors.fill: parent
        colors: previewPane.colors
        currentItem: previewPane.currentItem
    }

    // Text preview
    ClipboardTextPreview {
        visible: previewPane.isClipboardMode
            && previewPane.currentItem !== null
            && !previewPane.currentItem.isImage
        anchors.fill: parent
        colors: previewPane.colors
        currentItem: previewPane.currentItem
    }
}
