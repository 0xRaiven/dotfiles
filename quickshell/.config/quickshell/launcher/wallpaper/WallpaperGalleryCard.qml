import QtQuick

Item {
    id: card

    property int itemIndex: 0
    property var colors
    property string name: ""
    property string preview: ""

    readonly property bool isCurrent: GridView.isCurrentItem

    signal clicked(int idx)
    signal doubleClicked(int idx)

    Rectangle {
        id: cardRect
        anchors.fill: parent
        anchors.margins: 4
        radius: 10
        clip: true
        color: Qt.rgba(colors.surfaceVariant.r, colors.surfaceVariant.g, colors.surfaceVariant.b, 0.40)
        border.width: (card.isCurrent || cardMouse.containsMouse) ? 2 : 1
        border.color: card.isCurrent
            ? colors.primary
            : (cardMouse.containsMouse
                ? Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.50)
                : Qt.rgba(colors.outline.r, colors.outline.g, colors.outline.b, 0.25))

        scale: cardMouse.containsMouse ? 1.03 : (card.isCurrent ? 1.02 : 1.0)
        Behavior on scale { NumberAnimation { duration: 120 } }
        Behavior on border.color { ColorAnimation { duration: 120 } }

        Image {
            anchors.fill: parent
            source: card.preview ? ("file://" + card.preview) : ""
            fillMode: Image.PreserveAspectCrop
            smooth: true
            asynchronous: true
            cache: true
            sourceSize.width: 180
            sourceSize.height: 110
        }

        // Dark vignette at bottom
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 24
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.85) }
            }
        }

        // Name label
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.right: checkPill.visible ? checkPill.left : parent.right
            anchors.rightMargin: 6
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            text: card.name
            color: Qt.rgba(1, 1, 1, 0.95)
            font.pixelSize: 11
            font.weight: card.isCurrent ? Font.DemiBold : Font.Normal
            elide: Text.ElideRight
        }

        // Selection indicator
        Rectangle {
            id: checkPill
            visible: card.isCurrent
            anchors.right: parent.right
            anchors.rightMargin: 6
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            width: 16
            height: 16
            radius: 8
            color: colors.primary

            Text {
                anchors.centerIn: parent
                text: "\u2713"
                color: colors.on_primary
                font.pixelSize: 9
                font.weight: Font.Bold
            }
        }

        MouseArea {
            id: cardMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: card.clicked(card.itemIndex)
            onDoubleClicked: card.doubleClicked(card.itemIndex)
        }
    }
}
