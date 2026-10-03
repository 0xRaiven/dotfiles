import QtQuick

Item {
    id: studio

    property var colors
    property var resultModel
    property int currentIndex: 0
    readonly property var currentItem: (resultModel && currentIndex >= 0
        && currentIndex < resultModel.count) ? resultModel.get(currentIndex) : null

    signal indexChanged(int index)
    signal applyRequested()

    // Ambient dynamic backdrop glow
    Image {
        anchors.fill: parent
        source: (studio.currentItem && studio.currentItem.preview)
            ? ("file://" + studio.currentItem.preview) : ""
        fillMode: Image.PreserveAspectCrop
        opacity: 0.12
        smooth: true
        cache: true
        asynchronous: true
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(colors.surface.r, colors.surface.g, colors.surface.b, 0.40)
        radius: 12
    }

    // Left: Hero Showcase (420px)
    WallpaperHero {
        id: heroShowcase
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 420
        colors: studio.colors
        currentItem: studio.currentItem
        currentIndex: studio.currentIndex
        totalCount: studio.resultModel ? studio.resultModel.count : 0
        onApplyClicked: studio.applyRequested()
        onRandomClicked: {
            if (studio.resultModel && studio.resultModel.count > 1) {
                var next = Math.floor(Math.random() * studio.resultModel.count)
                if (next === studio.currentIndex)
                    next = (next + 1) % studio.resultModel.count
                studio.indexChanged(next)
            }
        }
    }

    // Right: Gallery Deck
    WallpaperGallery {
        id: galleryDeck
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: heroShowcase.right
        anchors.leftMargin: 12
        anchors.right: parent.right
        colors: studio.colors
        resultModel: studio.resultModel
        currentIndex: studio.currentIndex
        onIndexChanged: function(idx) { studio.indexChanged(idx) }
        onItemApplied: studio.applyRequested()
    }
}
