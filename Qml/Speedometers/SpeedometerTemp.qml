import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Shapes 1.15

Item {
    id: speedometerTemp
    width: 300
    height: 300

    property real temp: 90
    property real speedMin: -40
    property real speedMax: 150
    property real angleStart: 135
    property real angleEnd: 405
    property real arcStrokeWidth: 10
    property real gaugeRadius: width / 2.6
    property real needleAngle: angleStart

    onWidthChanged: {
        gaugeRadius = width / 2.6
        canvas.requestPaint()
    }

    onTempChanged: {
        needleAngle = angleStart + ((temp - speedMin) / (speedMax - speedMin)) * (angleEnd - angleStart) + 90
        comConnector.changeTempToOBD(temp);
    }

    Component.onCompleted: {
        gaugeRadius = width / 2.6
        needleAngle = angleStart + ((temp - speedMin) / (speedMax - speedMin)) * (angleEnd - angleStart) + 90
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

            var totalRange = speedMax - speedMin;

            for (var i = 0; i <= (totalRange / smallTickStep); i++) {
                var value = speedMin + (i * smallTickStep)
                var fraction = (value - speedMin) / totalRange
                var angle = angleStart + fraction * (angleEnd - angleStart)
                var rad = angle * (Math.PI / 180)

                var isBigTick = value % bigTickStep === 0 || value === speedMin
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

                    ctx.font = "bold 13px Roboto";
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
        text: "°C"
        font.pixelSize: 26
        font.family: "Roboto"
        color: "#FFFFFF"
        font.bold: true
    }

    TextEdit {
        id: temp_text
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 70
        text: Math.round(temp)
        font.pixelSize: 36
        font.family: "Roboto"
        selectByMouse: true
        color: "#FFFFFF"
        font.bold: true

        onTextChanged: {
            if (Number(text) > speedMax) {
                temp = speedMax
            } else if (Number(text) < speedMin && text !== "-" && text !== "") {
                temp = speedMin
            } else if (text !== "-" && text !== "") {
                temp = Number(text)
            }
        }
    }

    Rectangle {
        id: increaseButton
        width: 40; height: 40; color: "#4CAF50"; radius: 10
        anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.bottomMargin: -8; anchors.leftMargin: 50
        Text { text: "+"; anchors.centerIn: parent; font.pixelSize: 20; font.bold: true; color: "#FFFFFF" }
        Timer {
            id: holdTimer
            interval: 50; repeat: true; running: false
            onTriggered: {
                temp = Math.min(temp + 1, speedMax)
                temp_text.text = Math.round(temp).toString()
            }
        }
        MouseArea {
            anchors.fill: parent
            onPressed: holdTimer.start()
            onReleased: holdTimer.stop()
            onClicked: {
                temp = Math.min(temp + 1, speedMax)
                temp_text.text = Math.round(temp).toString()
            }
        }
    }

    Rectangle {
        id: decreaseButton
        width: 40; height: 40; color: "#F44336"; radius: 10
        anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.bottomMargin: -8; anchors.leftMargin: 95
        Text { text: "-"; anchors.centerIn: parent; font.pixelSize: 20; font.bold: true; color: "#FFFFFF" }
        Timer {
            id: decreaseTimer
            interval: 50; repeat: true; running: false
            onTriggered: {
                temp = Math.max(temp - 1, speedMin)
                temp_text.text = Math.round(temp).toString()
            }
        }
        MouseArea {
            anchors.fill: parent
            onPressed: decreaseTimer.start()
            onReleased: decreaseTimer.stop()
            onClicked: {
                temp = Math.max(temp - 1, speedMin)
                temp_text.text = Math.round(temp).toString()
            }
        }
    }

    Slider {
        id: tempSlider
        from: speedMin
        to: speedMax
        value: temp
        stepSize: 1
        anchors.left: parent.left; anchors.leftMargin: 140; anchors.bottom: parent.bottom; anchors.bottomMargin: 6
        width: 100; height: 8

        background: Rectangle {
            y: (tempSlider.availableHeight - height) / 2
            width: tempSlider.availableWidth; height: 8; radius: 4; color: "#25334C"
            Rectangle {
                width: tempSlider.handle.x + tempSlider.handle.width / 2
                height: parent.height; color: "#26C3F6"; radius: 4
            }
        }
        handle: Rectangle {
            x: tempSlider.leftPadding + tempSlider.visualPosition * (tempSlider.availableWidth - width)
            y: tempSlider.topPadding + (tempSlider.availableHeight - height) / 2
            width: 15; height: 15; radius: 10; color: "#26C3F6"
        }
        onValueChanged: {
            temp = Math.round(value);
            temp_text.text = Math.round(temp).toString();
        }
    }
}
