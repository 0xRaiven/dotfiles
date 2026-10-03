import QtQuick

Rectangle {
    id: searchBar

    property var colors
    property string placeholderText: "Search"
    property alias text: searchInput.text
    property alias cursorPosition: searchInput.cursorPosition
    readonly property bool inputFocused: searchInput.activeFocus

    signal escapePressed()
    signal returnPressed()
    signal downPressed()
    signal upPressed()
    signal rightPressed()
    signal leftPressed()

    function forceActiveFocus() {
        searchInput.forceActiveFocus()
    }

    height: 52
    radius: 26
    clip: true
    color: Qt.rgba(colors.surface.r, colors.surface.g, colors.surface.b, 0.90)
    border.width: 1
    border.color: searchInput.activeFocus
        ? Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.55)
        : Qt.rgba(colors.outline.r, colors.outline.g, colors.outline.b, 0.25)

    Behavior on border.color {
        ColorAnimation { duration: 150 }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: searchInput.forceActiveFocus()
    }

    // Magnifying glass icon
    Text {
        id: searchIcon
        anchors.left: parent.left
        anchors.leftMargin: 18
        anchors.verticalCenter: parent.verticalCenter
        text: "\uf002"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 18
        color: searchInput.activeFocus ? colors.primary : colors.muted

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }

    // Search Text Input
    TextInput {
        id: searchInput
        anchors.left: searchIcon.right
        anchors.leftMargin: 12
        anchors.right: clearButton.visible ? clearButton.left : parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        color: colors.foreground
        selectionColor: Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.50)
        selectedTextColor: colors.on_primary
        font.pixelSize: 18
        font.weight: Font.Normal
        focus: true
        clip: true

        Keys.onEscapePressed: searchBar.escapePressed()
        Keys.onReturnPressed: searchBar.returnPressed()
        Keys.onEnterPressed: searchBar.returnPressed()
        Keys.onDownPressed: searchBar.downPressed()
        Keys.onUpPressed: searchBar.upPressed()
        Keys.onRightPressed: searchBar.rightPressed()
        Keys.onLeftPressed: searchBar.leftPressed()
    }

    // Placeholder Text
    Text {
        visible: searchInput.text.length === 0
        anchors.left: searchIcon.right
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        text: searchBar.placeholderText
        color: colors.muted
        font.pixelSize: 18
        font.weight: Font.Light
    }

    // Clear Button
    Rectangle {
        id: clearButton
        visible: searchInput.text.length > 0
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        width: 22
        height: 22
        radius: 11
        color: clearMouse.containsMouse
            ? Qt.rgba(colors.surfaceVariant.r, colors.surfaceVariant.g, colors.surfaceVariant.b, 0.90)
            : Qt.rgba(colors.surfaceVariant.r, colors.surfaceVariant.g, colors.surfaceVariant.b, 0.50)

        Text {
            anchors.centerIn: parent
            text: "\u2715"
            color: colors.muted
            font.pixelSize: 11
        }

        MouseArea {
            id: clearMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                searchInput.text = ""
                searchInput.forceActiveFocus()
            }
        }
    }
}
