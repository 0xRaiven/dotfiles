import QtQuick
import "results"
import "clipboard"
import "wallpaper"

Rectangle {
    id: resultsCard

    property var colors
    property string activeMode: "search"
    property var resultModel
    property string calculation: ""
    property bool isWallpaperMode: false
    property bool isClipboardMode: false
    property bool isDualPane: false
    property bool resultsVisible: false
    property bool clipboardLoaderRunning: false
    property bool wallpaperLoaderRunning: false

    property int currentIndex: 0
    readonly property var currentItem: (resultModel && currentIndex >= 0
        && currentIndex < resultModel.count) ? resultModel.get(currentIndex) : null

    signal itemActivated()

    function incrementIndex() {
        if (resultModel && currentIndex < resultModel.count - 1)
            currentIndex++
    }

    function decrementIndex() {
        if (currentIndex > 0)
            currentIndex--
    }

    function incrementIndexWallpaper() {
        if (!resultModel) return
        var next = currentIndex + 2
        if (next < resultModel.count) currentIndex = next
        else currentIndex = resultModel.count - 1
    }

    function decrementIndexWallpaper() {
        var prev = currentIndex - 2
        if (prev >= 0) currentIndex = prev
        else currentIndex = 0
    }

    function incrementIndexByOne() {
        if (resultModel && currentIndex + 1 < resultModel.count)
            currentIndex++
    }

    function decrementIndexByOne() {
        if (currentIndex > 0)
            currentIndex--
    }

    // === Visual ===

    visible: resultsVisible
    opacity: resultsVisible ? 1.0 : 0.0
    height: {
        if (!resultsVisible) return 0
        if (isWallpaperMode) return 510
        if (isDualPane) return 490
        if (resultModel && resultModel.count > 0) return Math.min(480, 16 + resultModel.count * 52)
        if (calculation.length > 0) return 120
        return 70
    }
    radius: 18
    color: Qt.rgba(colors.surface.r, colors.surface.g, colors.surface.b, 0.94)
    border.width: 1
    border.color: Qt.rgba(colors.outline.r, colors.outline.g, colors.outline.b, 0.25)
    clip: true

    Behavior on height {
        NumberAnimation { duration: 250; easing.type: Easing.OutQuint }
    }
    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    // Prevent dismiss when clicking inside results
    MouseArea {
        anchors.fill: parent
        onClicked: {}
    }

    // Calculation display
    CalculationPane {
        visible: calculation.length > 0 && (!resultModel || resultModel.count === 0)
        anchors.fill: parent
        colors: resultsCard.colors
        calculation: resultsCard.calculation
    }

    // Empty state
    EmptyState {
        visible: resultsVisible && (!resultModel || resultModel.count === 0) && calculation.length === 0
        anchors.fill: parent
        colors: resultsCard.colors
        activeMode: resultsCard.activeMode
        wallpaperLoaderRunning: resultsCard.wallpaperLoaderRunning
        clipboardLoaderRunning: resultsCard.clipboardLoaderRunning
    }

    // === Main Content (non-wallpaper modes) ===
    Item {
        id: contentArea
        visible: resultsVisible && resultModel && resultModel.count > 0 && !isWallpaperMode
        anchors.fill: parent
        anchors.margins: 8

        // Results List
        ListView {
            id: resultList
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: isDualPane ? 320 : parent.width
            spacing: 3
            clip: true
            model: resultsCard.resultModel
            currentIndex: resultsCard.currentIndex
            boundsBehavior: Flickable.StopAtBounds

            Behavior on width {
                NumberAnimation { duration: 220; easing.type: Easing.OutQuint }
            }

            delegate: ResultDelegate {
                colors: resultsCard.colors
                isDualPane: resultsCard.isDualPane
                itemIndex: model.index
                itemId: model.id
                name: model.name
                subtitle: model.subtitle
                kind: model.kind
                mime: model.mime || ""
                label: model.label || ""
                isImage: model.isImage
                preview: model.preview
                icon: model.icon
                onActivated: function(idx) {
                    resultsCard.currentIndex = idx
                    resultsCard.itemActivated()
                }
            }
        }

        // Sync currentIndex → ListView
        Connections {
            target: resultsCard
            function onCurrentIndexChanged() {
                if (resultList.currentIndex !== resultsCard.currentIndex)
                    resultList.currentIndex = resultsCard.currentIndex
            }
        }

        // Vertical Divider (dual-pane)
        Rectangle {
            id: verticalDivider
            visible: isDualPane
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: resultList.right
            anchors.leftMargin: 6
            width: 1
            color: Qt.rgba(colors.outline.r, colors.outline.g, colors.outline.b, 0.20)
        }

        // Preview Pane (dual-pane clipboard)
        PreviewPane {
            visible: isDualPane
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: verticalDivider.right
            anchors.right: parent.right
            anchors.margins: 12
            colors: resultsCard.colors
            currentItem: resultsCard.currentItem
            isClipboardMode: resultsCard.isClipboardMode
            clipboardLoaderRunning: resultsCard.clipboardLoaderRunning
        }
    }

    // === Wallpaper Studio ===
    WallpaperStudio {
        visible: resultsVisible && resultModel && resultModel.count > 0 && isWallpaperMode
        anchors.fill: parent
        anchors.margins: 12
        colors: resultsCard.colors
        resultModel: resultsCard.resultModel
        currentIndex: resultsCard.currentIndex
        onIndexChanged: function(idx) { resultsCard.currentIndex = idx }
        onApplyRequested: resultsCard.itemActivated()
    }
}
