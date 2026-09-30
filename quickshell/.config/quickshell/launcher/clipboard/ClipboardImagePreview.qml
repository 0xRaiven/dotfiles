import QtQuick

Item {
    id: imagePreview

    property var colors
    property var currentItem: null

    Column {
        anchors.fill: parent
        spacing: 10

        Rectangle {
            width: parent.width
            height: parent.height - 70
            radius: 10
            color: Qt.rgba(colors.background.r, colors.background.g, colors.background.b, 0.55)
            border.width: 1
            border.color: Qt.rgba(colors.outline.r, colors.outline.g, colors.outline.b, 0.25)
            clip: true

            Image {
                id: fullImagePreview
                anchors.fill: parent
                anchors.margins: 8
                source: (imagePreview.currentItem && imagePreview.currentItem.preview)
                    ? imagePreview.currentItem.preview : ""
                fillMode: Image.PreserveAspectFit
                smooth: true
                asynchronous: true
                cache: false
            }
        }

        Row {
            width: parent.width
            spacing: 8

            Rectangle {
                height: 22
                width: mimeText.implicitWidth + 12
                radius: 5
                color: Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.25)
                border.width: 1
                border.color: Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.45)

                Text {
                    id: mimeText
                    anchors.centerIn: parent
                    text: (imagePreview.currentItem && imagePreview.currentItem.mime)
                        ? imagePreview.currentItem.mime : "image/png"
                    color: colors.primary
                    font.pixelSize: 10
                    font.weight: Font.DemiBold
                }
            }

            Text {
                text: (imagePreview.currentItem && imagePreview.currentItem.label)
                    ? imagePreview.currentItem.label.replace(/^\[\[\s*binary data\s*/i, "").replace(/\s*\]\]$/, "")
                    : ""
                color: colors.muted
                font.pixelSize: 11
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
            }
        }

        Text {
            text: "Press \u21A9 Return to paste image"
            color: colors.muted
            font.pixelSize: 11
        }
    }
}
