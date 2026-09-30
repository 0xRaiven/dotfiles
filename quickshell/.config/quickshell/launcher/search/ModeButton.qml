import QtQuick
import QtQuick.Shapes

Rectangle {
    id: modeButton

    property var colors
    property string mode: ""
    property string activeMode: ""
    property string iconText: ""
    property string svgPath: ""
    readonly property bool useSvgIcon: svgPath.length > 0
    readonly property bool isActive: activeMode === mode
    readonly property alias containsMouse: mouseArea.containsMouse

    signal clicked()

    width: 52
    height: 52
    radius: 26
    color: isActive
        ? Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.35)
        : (mouseArea.containsMouse
            ? Qt.rgba(colors.surfaceVariant.r, colors.surfaceVariant.g, colors.surfaceVariant.b, 0.90)
            : Qt.rgba(colors.surface.r, colors.surface.g, colors.surface.b, 0.90))
    border.width: 1
    border.color: isActive
        ? colors.primary
        : (mouseArea.containsMouse
            ? Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.40)
            : Qt.rgba(colors.outline.r, colors.outline.g, colors.outline.b, 0.25))

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }

    // Text icon (Files, Wallpapers, Clipboard)
    Text {
        visible: !modeButton.useSvgIcon
        anchors.centerIn: parent
        text: modeButton.iconText
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 22
        color: modeButton.isActive
            ? colors.primary
            : (mouseArea.containsMouse ? colors.foreground : colors.muted)
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    // SVG vector icon (Apps button)
    Shape {
        visible: modeButton.useSvgIcon
        anchors.centerIn: parent
        width: 22
        height: 22
        preferredRendererType: Shape.CurveRenderer
        layer.enabled: true
        layer.samples: 4

        ShapePath {
            fillColor: modeButton.isActive
                ? colors.primary
                : (mouseArea.containsMouse ? colors.foreground : colors.muted)
            strokeColor: "transparent"
            strokeWidth: 0

            Behavior on fillColor { ColorAnimation { duration: 150 } }

            PathSvg {
                path: modeButton.svgPath
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: modeButton.clicked()
    }
}
