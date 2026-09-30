import QtQuick

Item {
    id: gallery

    property var colors
    property var resultModel
    property int currentIndex: 0

    signal indexChanged(int index)
    signal itemApplied()

    // Gallery Header
    Item {
        id: galleryHeader
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 20

        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            Text {
                text: "GALLERY"
                font.pixelSize: 10
                font.weight: Font.Bold
                font.letterSpacing: 1.2
                color: colors.muted
            }

            Rectangle {
                width: countText.implicitWidth + 8
                height: 16
                radius: 4
                color: Qt.rgba(colors.surfaceVariant.r, colors.surfaceVariant.g, colors.surfaceVariant.b, 0.50)

                Text {
                    id: countText
                    anchors.centerIn: parent
                    text: gallery.resultModel ? String(gallery.resultModel.count) : "0"
                    color: colors.muted
                    font.pixelSize: 10
                    font.weight: Font.Medium
                }
            }
        }

        Text {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: "\u2191\u2193\u2190\u2192 browse"
            font.pixelSize: 10
            color: colors.muted
        }
    }

    // 2-Column Grid
    GridView {
        id: wallpaperGrid
        anchors.top: galleryHeader.bottom
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cellWidth: Math.floor(width / 2)
        cellHeight: Math.floor((cellWidth - 8) * 0.60) + 24
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        model: gallery.resultModel

        delegate: WallpaperGalleryCard {
            width: wallpaperGrid.cellWidth
            height: wallpaperGrid.cellHeight
            colors: gallery.colors
            name: model.name
            preview: model.preview
            itemIndex: model.index
            onClicked: function(idx) {
                wallpaperGrid.currentIndex = idx
                gallery.indexChanged(idx)
            }
            onDoubleClicked: function(idx) {
                wallpaperGrid.currentIndex = idx
                gallery.indexChanged(idx)
                gallery.itemApplied()
            }
        }
    }

    // Sync external currentIndex → grid
    onCurrentIndexChanged: {
        if (wallpaperGrid.currentIndex !== currentIndex)
            wallpaperGrid.currentIndex = currentIndex
        wallpaperGrid.positionViewAtIndex(currentIndex, GridView.Contain)
    }
}
