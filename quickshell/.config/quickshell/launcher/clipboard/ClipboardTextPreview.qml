import QtQuick

Item {
    id: textPreview

    property var colors
    property var currentItem: null

    Column {
        anchors.fill: parent
        spacing: 12

        Text {
            text: "Clipboard Text Entry"
            color: colors.muted
            font.pixelSize: 12
            font.weight: Font.DemiBold
        }

        Rectangle {
            width: parent.width
            height: parent.height - 60
            radius: 10
            color: Qt.rgba(colors.background.r, colors.background.g, colors.background.b, 0.55)
            border.width: 1
            border.color: Qt.rgba(colors.outline.r, colors.outline.g, colors.outline.b, 0.25)
            clip: true

            Flickable {
                anchors.fill: parent
                anchors.margins: 12
                contentWidth: width
                contentHeight: textContent.implicitHeight
                clip: true

                Text {
                    id: textContent
                    width: parent.width
                    text: textPreview.currentItem ? textPreview.currentItem.name : ""
                    color: colors.foreground
                    font.pixelSize: 13
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
            }
        }

        Text {
            text: "Press \u21A9 Return to restore to clipboard"
            color: colors.muted
            font.pixelSize: 11
        }
    }
}
