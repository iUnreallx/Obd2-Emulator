import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Shapes 1.15

Item {
    id: speedometerVoltage
    width: 300
    height: 300

    property real voltage: 14.2
    property real speedMin: 0
    property real speedMax: 18
    property real angleStart: 135
    property real angleEnd: 405
    property real arcStrokeWidth: 10
    property real gaugeRadius: width / 2.6
    property real needleAngle: angleStart

    onWidthChanged: {
        gaugeRadius = width / 2.6
        canvas.requestPaint()
    }

    onVoltageChanged: {
        needleAngle = angleStart + ((voltage - speedMin) / (speedMax - speedMin)) * (angleEnd - angleStart) + 90
        comConnector.changeVoltageToOBD(voltage);
    }

    Component.onCompleted: {
        gaugeRadius = width / 2.6
        needleAngle = angleStart + ((voltage - speedMin) / (speedMax - speedMin)) * (angleEnd - angleStart) + 90
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

            var bigTickStep = 2 // Напряжение маленькое, цифры ставим каждые 2 Вольта
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
        width: 26; height: 26; radius: 13; color: "#FFFFFF"; anchors.centerIn: parent
    }

    Rectangle {
        width: 20; height: 20; radius: 10; color: "#111111"; anchors.centerIn: parent
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 45
        text: "V"
        font.pixelSize: 26
        font.family: "Roboto"
        color: "#FFFFFF"
        font.bold: true
    }

    Text {
        id: voltage_text
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 70
        text: voltage.toFixed(1) // Показываем 1 знак после запятой
        font.pixelSize: 36
        font.family: "Roboto"
        color: "#FFFFFF"
        font.bold: true
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
                voltage = Math.min(voltage + 0.1, speedMax)
            }
        }
        MouseArea {
            anchors.fill: parent
            onPressed: holdTimer.start()
            onReleased: holdTimer.stop()
            onClicked: { voltage = Math.min(voltage + 0.1, speedMax) }
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
                voltage = Math.max(voltage - 0.1, speedMin)
            }
        }
        MouseArea {
            anchors.fill: parent
            onPressed: decreaseTimer.start()
            onReleased: decreaseTimer.stop()
            onClicked: { voltage = Math.max(voltage - 0.1, speedMin) }
        }
    }

    Slider {
        id: voltageSlider
        from: speedMin
        to: speedMax
        value: voltage
        stepSize: 0.1
        anchors.left: parent.left; anchors.leftMargin: 140; anchors.bottom: parent.bottom; anchors.bottomMargin: 6
        width: 100; height: 8

        background: Rectangle {
            y: (voltageSlider.availableHeight - height) / 2
            width: voltageSlider.availableWidth; height: 8; radius: 4; color: "#25334C"
            Rectangle {
                width: voltageSlider.handle.x + voltageSlider.handle.width / 2
                height: parent.height; color: "#26C3F6"; radius: 4
            }
        }
        handle: Rectangle {
            x: voltageSlider.leftPadding + voltageSlider.visualPosition * (voltageSlider.availableWidth - width)
            y: voltageSlider.topPadding + (voltageSlider.availableHeight - height) / 2
            width: 15; height: 15; radius: 10; color: "#26C3F6"
        }
        onValueChanged: {
            voltage = value; // При дробях Math.round не делаем!
        }
    }
}
