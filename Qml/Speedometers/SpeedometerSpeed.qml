import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Shapes 1.15

Item {
    id: speedometer
    width: 300
    height: 300

    property real speed: 0
    property real speedMin: 0
    property real speedMax: 280
    property real angleStart: 135
    property real angleEnd: 405
    property real arcStrokeWidth: 10
    property real gaugeRadius: width / 2.6
    property real needleAngle: angleStart



    onWidthChanged: {
        gaugeRadius = width / 2.6
        canvas.requestPaint()
    }

    onSpeedChanged: {
        needleAngle = angleStart + ((speed - speedMin) / (speedMax - speedMin)) * (angleEnd - angleStart) + 90
        comConnector.changeSpeedToOBD(speed);
    }

    Component.onCompleted: {
        gaugeRadius = width / 2.6
        needleAngle = angleStart + 90
    }

    Canvas {
        id: canvas
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        renderStrategy: Canvas.Threaded

        onPaint: {
            var ctx = canvas.getContext("2d")
            ctx.clearRect(0, 0, canvas.width, canvas.height)

            if (gaugeRadius <= arcStrokeWidth / 2) return

            ctx.beginPath()
            ctx.arc(canvas.width / 2, canvas.height / 2, gaugeRadius, 0, Math.PI * 2)
            ctx.fillStyle = "#1C2526"
            ctx.fill()

            var bigTickStep = 20
            var smallDivisions = 4
            var smallTickStep = bigTickStep / smallDivisions
            for (var i = 0; i <= (speedMax / smallTickStep); i++) {
                var value = i * smallTickStep
                var fraction = value / speedMax
                var angle = angleStart + fraction * (angleEnd - angleStart)
                var rad = angle * (Math.PI / 180)

                var isBigTick = value % bigTickStep === 0
                var tickColor = isBigTick ? "#FFFFFF" : "#BBBBBB"
                var tickWidth = isBigTick ? 2 : 1.5
                var tickLength = isBigTick ? 0.5 : 0.01

                var startRadius = gaugeRadius - tickLength - 20
                var endRadius = gaugeRadius - 5

                var startX = canvas.width / 2 + Math.cos(rad) * startRadius
                var startY = canvas.height / 2 + Math.sin(rad) * startRadius
                var endX = canvas.width / 2 + Math.cos(rad) * endRadius
                var endY = canvas.height / 2 + Math.sin(rad) * endRadius

                ctx.beginPath()
                ctx.moveTo(startX, startY)
                ctx.lineTo(endX, endY)
                ctx.lineWidth = tickWidth
                ctx.strokeStyle = tickColor
                ctx.stroke()

                if (isBigTick) {
                    var textRadius = gaugeRadius - 35;
                    var textX = canvas.width / 2 + Math.cos(rad) * textRadius;
                    var textY = canvas.height / 2 + Math.sin(rad) * textRadius + 5;

                    if (value <= 159) {
                        textX -= 1.5;
                    }


                    if (value % 40 === 0) {
                        ctx.font = "bold 13px Roboto";
                    } else {
                        ctx.font = "13px Roboto";
                    }

                    ctx.fillStyle = "#FFFFFF";
                    ctx.textAlign = "center";
                    ctx.fillText(value, textX, textY);
                }
            }
        }
    }

    Shape {
        id: needle
        width: 13
        height: gaugeRadius - 40
        anchors.verticalCenterOffset: -38

        ShapePath {
            fillColor: "#FFFFFF"
            strokeWidth: 0

            startX: needle.width / 2
            startY: 0
            PathLine { x: 0; y: needle.height }
            PathLine { x: needle.width; y: needle.height }
            PathLine { x: needle.width / 2; y: 0 }
        }

        anchors.centerIn: parent

        transform: Rotation {
            origin.x: needle.width / 2
            origin.y: needle.height
            angle: needleAngle
        }
    }

    Rectangle {
        width: 26
        height: 26
        radius: 13
        color: "#FFFFFF"
        anchors.centerIn: parent
    }

    Rectangle {
        width: 20
        height: 20
        radius: 10
        color: "#111111"
        anchors.centerIn: parent
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 45
        text: "Km/h"
        font.pixelSize: 26
        font.family: "Roboto"
        color: "#FFFFFF"
        font.bold: true
    }




    TextEdit {
         id: kmh_text
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 70
        text: Math.round(speed)
        font.pixelSize: 36
        font.family: "Roboto"
        selectByMouse: true
        color: "#FFFFFF"
        font.bold: true

        onTextChanged: {
            if (text > 280) {
                speed = 280
            } else {
                speed = text
            }

            text = text.replace(/[^0-9]/g, "");

            if (text.length > 1 && text[0] === "0") {
                text = text.substring(1);
            }

            if (text.length > 3) {
                text = text.substring(0, 3);
            }

            if (!/^\d+$/.test(text)) {
                text = "";
            }
        }
    }


    Rectangle {
        id: increaseButton
        width: 40
        height: 40
        color: "#4CAF50"
        radius: 10
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -8
        anchors.leftMargin: 50

        state: "normal"
        Text {
            id: buttonText
            text: "+"
            anchors.centerIn: parent
            font.pixelSize: 20
            font.bold: true
            color: "#FFFFFF"
        }

        states: [
            State {
                name: "normal"
                PropertyChanges { target: increaseButton; width: 40; height: 40 }
                PropertyChanges { target: buttonText; font.pixelSize: 20 }
            },
            State {
                name: "pressed"
                PropertyChanges { target: increaseButton; width: 35; height: 35 }
                PropertyChanges { target: buttonText; font.pixelSize: 18 }
            }
        ]

        transitions: [
            Transition {
                from: "normal"
                to: "pressed"
                PropertyAnimation { properties: "width,height,font.pixelSize"; duration: 150; easing.type: Easing.InOutQuad }
            },
            Transition {
                from: "pressed"
                to: "normal"
                PropertyAnimation { properties: "width,height,font.pixelSize"; duration: 150; easing.type: Easing.InOutQuad }
            }
        ]

        Timer {
            id: holdTimer
            interval: 50
            repeat: true
            running: false
            onTriggered: {
                speed = Math.min(speed + 1, speedMax)
                kmh_text.text = Math.round(speed).toString()
            }
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                increaseButton.state = "pressed"
                holdTimer.start()
            }
            onReleased: {
                increaseButton.state = "normal"
                holdTimer.stop()
            }
            onClicked: {
                speed = Math.min(speed + 1, speedMax)
                kmh_text.text = Math.round(speed).toString()
            }
        }
    }



    Rectangle {
        id: decreaseButton
        width: 40
        height: 40
        color: "#F44336"
        radius: 10
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -8
        anchors.leftMargin: 95

        state: "normal"
        Text {
            id: decreaseText
            text: "-"
            anchors.centerIn: parent
            font.pixelSize: 20
            font.bold: true
            color: "#FFFFFF"
        }

        states: [
            State {
                name: "normal"
                PropertyChanges { target: decreaseButton; width: 40; height: 40 }
                PropertyChanges { target: decreaseText; font.pixelSize: 20 }
            },
            State {
                name: "pressed"
                PropertyChanges { target: decreaseButton; width: 35; height: 35 }
                PropertyChanges { target: decreaseText; font.pixelSize: 18 }
            }
        ]

        transitions: [
            Transition {
                from: "normal"
                to: "pressed"
                PropertyAnimation { properties: "width,height,font.pixelSize"; duration: 150; easing.type: Easing.InOutQuad }
            },
            Transition {
                from: "pressed"
                to: "normal"
                PropertyAnimation { properties: "width,height,font.pixelSize"; duration: 150; easing.type: Easing.InOutQuad }
            }
        ]

        Timer {
            id: decreaseTimer
            interval: 50
            repeat: true
            running: false
            onTriggered: {
                speed = Math.max(speed - 1, speedMin)
                kmh_text.text = Math.round(speed).toString()
            }
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                decreaseButton.state = "pressed"
                decreaseTimer.start()
            }
            onReleased: {
                decreaseButton.state = "normal"
                decreaseTimer.stop()
            }
            onClicked: {
                speed = Math.max(speed - 1, speedMin)
                kmh_text.text = Math.round(speed).toString()
            }
        }
    }


    Slider {
        id: speedSlider
        from: speedMin
        to: speedMax
        value: speed
        stepSize: 1
        anchors.left: parent.left
        anchors.leftMargin: 140
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 6
        width: 100
        height: 8

        background: Rectangle {
            x: 0
            y: (speedSlider.availableHeight - height) / 2
            implicitWidth: 100
            implicitHeight: 8
            width: speedSlider.availableWidth
            height: implicitHeight
            radius: 4
            color: "#25334C"

            Rectangle {
                width: speedSlider.handle.x + speedSlider.handle.width / 2
                height: parent.height
                color: "#26C3F6"
                radius: 4
            }
        }

        handle: Rectangle {
            x: speedSlider.leftPadding + speedSlider.visualPosition * (speedSlider.availableWidth - width)
            y: speedSlider.topPadding + (speedSlider.availableHeight - height) / 2
            width: 15
            height: 15
            radius: 10
            color: "#26C3F6"
        }

        onValueChanged: {
            speed = Math.round(value);
            kmh_text.text = Math.round(speed).toString();
        }
    }
}
