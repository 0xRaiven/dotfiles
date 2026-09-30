import QtQuick

Item {
    id: hero

    property var colors
    property var currentItem: null
    property int currentIndex: 0
    property int totalCount: 0

    signal applyClicked()
    signal randomClicked()

    Rectangle {
        anchors.fill: parent
        radius: 14
        color: Qt.rgba(colors.background.r, colors.background.g, colors.background.b, 0.70)
        border.width: 1
        border.color: Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.35)
        clip: true

        Image {
            id: heroImage
            anchors.fill: parent
            source: (hero.currentItem && hero.currentItem.preview)
                ? ("file://" + hero.currentItem.preview) : ""
            fillMode: Image.PreserveAspectCrop
            smooth: true
            asynchronous: true
            cache: true
        }

        // Top gradient vignette
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 64
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.60) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        // Bottom gradient vignette
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 80
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.85) }
            }
        }

        // Top Floating Header Row
        Item {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            height: 28

            // Title pill
            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                height: 26
                width: heroTitleRow.implicitWidth + 18
                radius: 13
                color: Qt.rgba(colors.surface.r, colors.surface.g, colors.surface.b, 0.85)
                border.width: 1
                border.color: Qt.rgba(colors.outline.r, colors.outline.g, colors.outline.b, 0.30)

                Row {
                    id: heroTitleRow
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        text: "\u{F09FE}"
                        color: colors.primary
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: (hero.currentItem && hero.currentItem.name)
                            ? hero.currentItem.name : ""
                        color: colors.foreground
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        anchors.verticalCenter: parent.verticalCenter
                        elide: Text.ElideRight
                    }
                }
            }

            // Shuffle / Random button
            Rectangle {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: 26
                width: randomBtnRow.implicitWidth + 16
                radius: 13
                color: randomMouse.containsMouse
                    ? Qt.rgba(colors.surfaceVariant.r, colors.surfaceVariant.g, colors.surfaceVariant.b, 0.90)
                    : Qt.rgba(colors.surface.r, colors.surface.g, colors.surface.b, 0.78)
                border.width: 1
                border.color: Qt.rgba(colors.outline.r, colors.outline.g, colors.outline.b, 0.30)

                Behavior on color { ColorAnimation { duration: 120 } }

                Row {
                    id: randomBtnRow
                    anchors.centerIn: parent
                    spacing: 5

                    Text {
                        text: "\uf074"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        color: colors.primary
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "Random"
                        color: colors.foreground
                        font.pixelSize: 11
                        font.weight: Font.Medium
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: randomMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: hero.randomClicked()
                }
            }
        }

        // Bottom Floating Glass Action Card
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10
            height: 48
            radius: 12
            color: Qt.rgba(colors.surface.r, colors.surface.g, colors.surface.b, 0.88)
            border.width: 1
            border.color: Qt.rgba(colors.outline.r, colors.outline.g, colors.outline.b, 0.28)

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Text {
                    text: (hero.currentItem && hero.currentItem.subtitle)
                        ? hero.currentItem.subtitle.replace(/^Wallpaper \u2022 /, "") : ""
                    color: colors.muted
                    font.pixelSize: 11
                    font.weight: Font.Normal
                    elide: Text.ElideRight
                }

                Rectangle {
                    width: 1; height: 12
                    color: Qt.rgba(colors.outline.r, colors.outline.g, colors.outline.b, 0.35)
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: (hero.currentIndex + 1) + "/" + hero.totalCount
                    color: colors.muted
                    font.pixelSize: 11
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // Apply Theme Button
            Rectangle {
                id: applyBtn
                anchors.right: parent.right
                anchors.rightMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                height: 34
                width: applyRow.implicitWidth + 20
                radius: 8
                color: applyMouse.containsMouse
                    ? Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.95)
                    : Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.80)

                Behavior on color { ColorAnimation { duration: 120 } }

                Row {
                    id: applyRow
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        text: "\u{F012C}"
                        color: colors.on_primary
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "Apply Theme"
                        color: colors.on_primary
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle {
                        width: returnKeyText.implicitWidth + 8
                        height: 18
                        radius: 4
                        color: Qt.rgba(0, 0, 0, 0.20)
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: returnKeyText
                            anchors.centerIn: parent
                            text: "\u21A9"
                            color: colors.on_primary
                            font.pixelSize: 10
                        }
                    }
                }

                MouseArea {
                    id: applyMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: hero.applyClicked()
                }
            }
        }

        // Click anywhere on hero to apply
        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: hero.applyClicked()
        }
    }
}
