import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Effects
import QtQuick.Controls

Rectangle {
    id: mainpage
    anchors.fill: parent
    color: "#000000"

    // Image {
    //     id: backgroundImage
    //     anchors.fill: parent
    //     source: "assets/car.jpg"
    // }

    // Item {
    //     width: 120
    //     height: 55
    //     anchors.right: parent.right

    //     Item {
    //         id: settingsButton
    //         width: 45
    //         height: 45
    //         anchors.top: parent.top
    //         anchors.right: parent.right
    //         anchors.rightMargin: 10
    //         anchors.topMargin: 10
    //         z: 1

    //         property color defaultColor: "#291B1B"
    //         property color hoverColor: "#000000"
    //         property color currentBackgroundColor: defaultColor
    //         property real opacityValue: 0.7

    //         Rectangle {
    //             anchors.fill: parent
    //             color: settingsButton.currentBackgroundColor
    //             radius: 13
    //             opacity: settingsButton.opacityValue
    //             z: 1
    //             Behavior on color {
    //                 ColorAnimation {
    //                     duration: 200
    //                 }
    //             }
    //             Behavior on opacity {
    //                 NumberAnimation {
    //                     duration: 200
    //                 }
    //             }
    //         }

    //         Image {
    //             anchors.centerIn: parent
    //             width: 35
    //             height: 35
    //             source: "assets/settings.png"
    //             z: 2
    //         }

    //         MouseArea {
    //             anchors.fill: parent
    //             cursorShape: Qt.PointingHandCursor
    //         }

    //         HoverHandler {
    //             onHoveredChanged: {
    //                 settingsButton.currentBackgroundColor = hovered ? settingsButton.hoverColor : settingsButton.defaultColor
    //                 settingsButton.opacityValue = hovered ? 1 : 0.7
    //             }
    //         }
    //     }

    //     Item {
    //         id: questionButton
    //         width: 45
    //         height: 45
    //         anchors.top: parent.top
    //         anchors.right: parent.right
    //         anchors.rightMargin: 65
    //         anchors.topMargin: 10
    //         z: 1

    //         property color defaultColor: "#291B1B"
    //         property color hoverColor: "#000000"
    //         property color currentBackgroundColor: defaultColor
    //         property real opacityValue: 0.7

    //         Rectangle {
    //             anchors.fill: parent
    //             color: questionButton.currentBackgroundColor
    //             radius: 13
    //             opacity: questionButton.opacityValue
    //             z: 1
    //             Behavior on color {
    //                 ColorAnimation {
    //                     duration: 200
    //                 }
    //             }
    //             Behavior on opacity {
    //                 NumberAnimation {
    //                     duration: 200
    //                 }
    //             }
    //         }

    //         Image {
    //             anchors.centerIn: parent
    //             width: 45
    //             height: 45
    //             source: "assets/question.png"
    //             z: 2
    //         }

    //         MouseArea {
    //             anchors.fill: parent
    //             cursorShape: Qt.PointingHandCursor
    //         }

    //         HoverHandler {
    //             onHoveredChanged: {
    //                 questionButton.currentBackgroundColor = hovered ? questionButton.hoverColor : questionButton.defaultColor
    //                 questionButton.opacityValue = hovered ? 1 : 0.7
    //             }
    //         }
    //     }
    // }

    // Item {
    //     width: 55
    //     height: 55
    //     anchors.right: parent.right
    //     anchors.bottom: parent.bottom
    //     anchors.rightMargin: 10
    //     anchors.bottomMargin: 8

    //     Item {
    //         id: nextButton
    //         width: 45
    //         height: 45
    //         anchors.centerIn: parent
    //         z: 1

    //         property color defaultColor: "#291B1B"
    //         property color hoverColor: "#000000"
    //         property color currentBackgroundColor: defaultColor
    //         property real opacityValue: 0.7

    //         Rectangle {
    //             anchors.fill: parent
    //             color: nextButton.currentBackgroundColor
    //             radius: 35
    //             opacity: nextButton.opacityValue
    //             z: 1
    //             Behavior on color {
    //                 ColorAnimation {
    //                     duration: 200
    //                 }
    //             }
    //             Behavior on opacity {
    //                 NumberAnimation {
    //                     duration: 200
    //                 }
    //             }
    //         }

    //         Image {
    //             anchors.centerIn: parent
    //             width: 20
    //             height: 20
    //             source: "assets/next.png"
    //             z: 2
    //         }

    //         MouseArea {
    //             anchors.fill: parent
    //             cursorShape: Qt.PointingHandCursor
    //             onClicked: {
    //                 root.changePage("Obd2Screen.qml")
    //             }
    //         }
    //         HoverHandler {
    //             onHoveredChanged: {
    //                 nextButton.currentBackgroundColor = hovered ? nextButton.hoverColor : nextButton.defaultColor
    //                 nextButton.opacityValue = hovered ? 1 : 0.7
    //             }
    //         }
    //     }
    // }








    // Rectangle {
    //     anchors.centerIn: parent
    //     width: 310
    //     height: 85
    //     color: "black"
    //     opacity: 0.5
    //     z: 1
    //     radius: 13
    // }


    // Text {
    //     font.pixelSize: 35
    //     text: "Welcome"
    //     color: "white"
    //     anchors.centerIn: parent
    //     z: 2
    //     font.bold: true
    // }

    // Item {
    //     width: 310
    //     height: 85
    //     anchors.centerIn: parent
    //     id: blurBlock


    //     Rectangle {
    //         anchors.fill: parent
    //         radius: 20
    //         clip: true

    //         ShaderEffectSource {
    //             id: clippedSource
    //             anchors.fill: parent
    //             sourceItem: backgroundImage
    //             sourceRect: Qt.rect(blurBlock.x, blurBlock.y, blurBlock.width, blurBlock.height)
    //             live: true
    //             recursive: false

    //         }

    //         ShaderEffect {
    //             anchors.fill: parent
    //             property variant src: clippedSource
    //             property real pixelStepX: 1.0 / width
    //             property real pixelStepY: 1.0 / height
    //             property int radius: 10
    //             property vector2d pixelStep: Qt.vector2d(pixelStepX, pixelStepY)
    //             property real cornerRadius: 13.0

    //             fragmentShader: "boxblur.frag.qsb"
    //         }
    //     }
    // }



}
