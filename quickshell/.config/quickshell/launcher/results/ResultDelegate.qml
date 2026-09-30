import QtQuick

Rectangle {
    id: delegate

    property var colors
    property bool isDualPane: false
    property int itemIndex: 0

    // Model data
    property string itemId: ""
    property string name: ""
    property string subtitle: ""
    property string kind: ""
    property string mime: ""
    property string label: ""
    property bool isImage: false
    property string preview: ""
    property string icon: ""

    readonly property bool isCurrent: ListView.isCurrentItem

    signal activated(int idx)

    width: ListView.view ? ListView.view.width - 6 : 300
    height: 48
    radius: 10
    color: isCurrent
        ? Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.28)
        : (itemMouse.containsMouse
            ? Qt.rgba(colors.surfaceVariant.r, colors.surfaceVariant.g, colors.surfaceVariant.b, 0.40)
            : "transparent")

    border.width: isCurrent ? 1 : 0
    border.color: Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.50)

    Behavior on color {
        ColorAnimation { duration: 100 }
    }

    // Leading Icon Badge
    Rectangle {
        id: itemBadge
        width: 32
        height: 32
        radius: 8
        clip: true
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        color: delegate.isCurrent
            ? Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.40)
            : Qt.rgba(colors.surfaceVariant.r, colors.surfaceVariant.g, colors.surfaceVariant.b, 0.55)

        Image {
            id: appIcon
            anchors.fill: parent
            anchors.margins: (delegate.kind === "wallpaper" || delegate.isImage) ? 0 : 4
            fillMode: (delegate.kind === "wallpaper" || delegate.isImage)
                ? Image.PreserveAspectCrop : Image.PreserveAspectFit
            asynchronous: true
            cache: true
            sourceSize.width: 64
            sourceSize.height: 64
            visible: status === Image.Ready && source.toString().length > 0
            source: {
                if ((delegate.kind === "wallpaper" || delegate.isImage) && delegate.preview) {
                    return delegate.preview.startsWith("file://")
                        ? delegate.preview : ("file://" + delegate.preview)
                }
                const iconName = delegate.icon || ""
                if (!iconName) return ""
                if (iconName.startsWith("/") || iconName.startsWith("file://")) {
                    return iconName.startsWith("file://")
                        ? iconName : ("file://" + iconName)
                }
                const cleanName = iconName.replace(/\.(png|svg|xpm)$/i, "")
                return "image://icon/" + cleanName
            }
        }

        Text {
            visible: !appIcon.visible
            anchors.centerIn: parent
            text: delegate.kind === "run" ? "\u26A1"
                : (delegate.kind === "app" ? "\u{F003B}"
                : (delegate.kind === "file" ? "\u{F024B}"
                : (delegate.kind === "command" ? ">_"
                : (delegate.kind === "wallpaper" ? "\u{F09FE}"
                : (delegate.isImage ? "\uD83D\uDDBC" : "\u{F018F}")))))
            font.family: "JetBrainsMono Nerd Font"
            color: colors.foreground
            font.pixelSize: 15
        }
    }

    // Title & Subtitle Column
    Column {
        anchors.left: itemBadge.right
        anchors.leftMargin: 12
        anchors.right: trailingHint.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 2

        Text {
            width: parent.width
            text: delegate.kind === "wallpaper" ? delegate.name
                : (delegate.isImage ? "Image Screenshot" : delegate.name)
            color: colors.foreground
            font.pixelSize: 13
            font.weight: delegate.isCurrent ? Font.DemiBold : Font.Normal
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            text: delegate.isImage ? delegate.subtitle
                : (delegate.subtitle || delegate.kind)
            color: delegate.isCurrent ? colors.foreground : colors.muted
            font.pixelSize: 11
            elide: Text.ElideRight
        }
    }

    // Trailing Action Pill or Chevron
    Item {
        id: trailingHint
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        width: delegate.isDualPane ? 16 : actionPill.implicitWidth
        height: 24

        Text {
            visible: delegate.isDualPane && delegate.isCurrent
            anchors.centerIn: parent
            text: "\u203A"
            color: colors.primary
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }

        Rectangle {
            id: actionPill
            visible: !delegate.isDualPane && delegate.isCurrent
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: 22
            width: actionPillText.implicitWidth + 14
            radius: 6
            color: Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.35)
            border.width: 1
            border.color: Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.55)

            Text {
                id: actionPillText
                anchors.centerIn: parent
                text: delegate.kind === "run" ? "\u21A9 Run"
                    : (delegate.kind === "app" ? "\u21A9 Open"
                    : (delegate.kind === "file" ? "\u21A9 Open"
                    : (delegate.kind === "command" ? "\u21A9 Run"
                    : (delegate.kind === "wallpaper" ? "\u21A9 Apply"
                    : "\u21A9 Select"))))
                color: colors.foreground
                font.pixelSize: 10
                font.weight: Font.DemiBold
            }
        }
    }

    MouseArea {
        id: itemMouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: delegate.activated(delegate.itemIndex)
    }
}
