import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Particles 2.15

Rectangle {
    id: mainpage
    anchors.fill: parent
    color: "#000000"

    property bool blurBlockHover: false

    Item {
        id: bgGroup
        anchors.fill: parent

        Image {
            id: backgroundImage
            anchors.fill: parent
            source: "assets/car.png"
        }
        ParticleSystem {
            id: particleSystem
            anchors.fill: parent
            running: true
        }
        Emitter {
            system: particleSystem
            emitRate: 3
            lifeSpan: 50000
            size: 8
            sizeVariation: 4
            width: parent.width - 200
            height: parent.height
            anchors.fill: parent
            startTime: 50000
            velocity: AngleDirection {
                angle: 290
                magnitude: 25
                magnitudeVariation: 15
            }
        }

        ImageParticle {
            system: particleSystem
            anchors.fill: parent
            source: "assets/circle.png"
            color: "white"
            colorVariation: 0.25
            entryEffect: ImageParticle.None
            opacity: 0.9
            alphaVariation: 0.25
        }
    }

    Item {
        width: 120
        height: 55
        anchors.right: parent.right
        Item {
            id: settingsButton
            width: 45
            height: 45
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.topMargin: 10
            z: 1
            property color defaultColor: "#291B1B"
            property color hoverColor: "#000000"
            property color currentBackgroundColor: defaultColor
            property real opacityValue: 0.9
            Rectangle {
                anchors.fill: parent
                color: settingsButton.currentBackgroundColor
                radius: 13
                opacity: settingsButton.opacityValue
                z: 1
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }
            Image {
                anchors.centerIn: parent
                width: 35
                height: 35
                source: "assets/settings.png"
                z: 2
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
            }
            HoverHandler {
                onHoveredChanged: {
                    settingsButton.currentBackgroundColor = hovered ? settingsButton.hoverColor : settingsButton.defaultColor
                    settingsButton.opacityValue = hovered ? 1 : 0.7
                }
            }
        }
        Item {
            id: questionButton
            width: 45
            height: 45
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 65
            anchors.topMargin: 10
            z: 1
            property color defaultColor: "#291B1B"
            property color hoverColor: "#000000"
            property color currentBackgroundColor: defaultColor
            property real opacityValue: 0.9
            Rectangle {
                anchors.fill: parent
                color: questionButton.currentBackgroundColor
                radius: 13
                opacity: questionButton.opacityValue
                z: 1
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }
            Image {
                anchors.centerIn: parent
                width: 45
                height: 45
                source: "assets/question.png"
                z: 2
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
            }
            HoverHandler {
                onHoveredChanged: {
                    questionButton.currentBackgroundColor = hovered ? questionButton.hoverColor : questionButton.defaultColor
                    questionButton.opacityValue = hovered ? 1 : 0.7
                }
            }
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: 310
        height: 85
        color: "black"
        opacity: mainpage.blurBlockHover ? 0.6 : 0.5
        z: 4
        radius: 50

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }


    Text {
        font.pixelSize: 35
        text: "Start"
        color: "white"
        anchors.centerIn: parent
        z: 4
        font.bold: true
    }

    Item {
        width: 310
        height: 85
        anchors.centerIn: parent
        id: blurBlock
        z: 3
        property bool blurBlockHover: false

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.changePage("Obd2Screen.qml")
            }
        }
            HoverHandler {
                onHoveredChanged: {
                    mainpage.blurBlockHover = hovered
                }
            }

        Rectangle {
            anchors.fill: parent
            radius: 20
            clip: true
            ShaderEffectSource {
                id: clippedSource
                anchors.fill: parent
                sourceItem: bgGroup
                sourceRect: Qt.rect(blurBlock.x, blurBlock.y, blurBlock.width, blurBlock.height)
                live: true
                recursive: false
            }
            ShaderEffect {
                anchors.fill: parent
                property variant src: clippedSource
                property real pixelStepX: 1.0 / width
                property real pixelStepY: 1.0 / height
                property int radius: 7
                property vector2d pixelStep: Qt.vector2d(pixelStepX, pixelStepY)
                property real cornerRadius: 50.0
                fragmentShader: "boxblur.frag.qsb"
            }
        }
    }
}
