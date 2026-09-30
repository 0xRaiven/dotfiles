import QtQuick

Item {
    id: calculationPane

    property var colors
    property string calculation: ""

    Row {
        anchors.centerIn: parent
        spacing: 16

        Text {
            text: "="
            color: colors.primary
            font.pixelSize: 34
            font.weight: Font.Light
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: calculationPane.calculation
            color: colors.foreground
            font.pixelSize: 36
            font.weight: Font.DemiBold
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
