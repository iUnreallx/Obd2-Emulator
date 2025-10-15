import QtQuick 2.15
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import QtQuick.Controls.Material 2.15
import QtQuick.Shapes 1.0
import "Speedometers" as Speedometers


Rectangle {
    id: mainpage
    anchors.fill: parent
    color: "#000001"

    property int power: 0
    property int fuel: 0
    property real temp: 0
    property real oilLevel: 0

    //speed
    Speedometers.SpeedometerSpeed {
        anchors.left: engine_prm.right
        anchors.top: parent.top
        anchors.leftMargin: -20
        anchors.topMargin: -10
    }

    //RPM
    Speedometers.SpeedometerRPM {
        anchors.left: engine_prm.right
        anchors.top: engine_prm.bottom
        anchors.leftMargin: -20
        anchors.topMargin: -10
        speed: 0
        speedMin: 0
        speedMax: 15000
    }

    Rectangle{
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 5
        anchors.rightMargin: 5
        width: 35
        height: 35
        color: "transparent"

        ColorOverlay {
            anchors.centerIn: parent
            width: 35
            height: 35
            source: Image {
                source: "assets/settings.png"
                width: 35
                height: 35
            }
            color: "#4178F6"
            z: 2
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                comPort.scanPorts()

                emulatorSettings.open()
                root.isOverlayVisible = true
            }
        }
    }

    Popup {
        id: emulatorSettings
        focus: true
        width: parent.width - 60
        height: parent.height - 60
        z: 4
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        clip: true

        onClosed: {
            comPort.clearPorts()
            root.isOverlayVisible = false;
        }

        background: Rectangle {
            color: "transparent"
        }

        // Rectangle {
        //     width: 25
        //     height: 25
        //     color: theme.button
        //     anchors.right: parent.right
        //     anchors.rightMargin: 15
        //     anchors.top: parent.top
        //     anchors.topMargin: 8
        //     radius: 10
        //     z: 2
        //     Image {
        //         source: "assets/images/parametrs/cross.png"
        //         anchors.centerIn: parent
        //         width: parent.width - 2
        //         height: parent.height - 2
        //     }
        //     MouseArea {
        //         anchors.fill: parent
        //         cursorShape: Qt.PointingHandCursor
        //         onClicked: {
        //             root.isOverlayVisible = false
        //             emulatorSettings.visible = false
        //         }
        //     }
        // }

        Rectangle {
            anchors.fill: parent
            color: "#140F0F"
            radius: 20
            clip: true

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 13
                text: "Connection settings"
                font.pixelSize: 28
                font.bold: true
                color: "white"
            }


            Text {
                id: comPortText
                anchors.left: parent.left
                anchors.leftMargin: 55
                anchors.top: parent.top
                anchors.topMargin: 60
                text: "Select the com-port"
                font.pixelSize: 28
                font.bold: true
                color: "white"
            }


            ComboBox {
                id: comPortComboBox
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 105
                width: parent.width - 74
                height: 50

                model: comPort.availablePorts.length > 0
                       ? comPort.availablePorts
                       : ["Нет доступных портов"]

                property color normalColor: "#2E1F1F"
                property color activeColor: "#261818"

                background: Rectangle {
                    radius: 25
                    color: comPortComboBox.hovered || comPortComboBox.popup.visible
                           ? comPortComboBox.activeColor
                           : comPortComboBox.normalColor
                }

                Rectangle {
                    id: reloadButton
                    width: 35
                    height: 35
                    color: "transparent"
                    radius: 50
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    z: 2

                    Image {
                        anchors.centerIn: parent
                        width: parent.width - 2
                        height: parent.height - 2
                        source: "assets/ui/reload.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            comPort.scanPorts()
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    onPressed: {
                        if (comPort.availablePorts.length > 0) {
                            comPortComboBox.popup.open()
                        }
                    }
                    z: 1
                }


                Rectangle {
                    id: terminalButton
                    width: 50
                    height: 45
                    color: "transparent"
                    radius: 50
                    anchors.right: parent.right
                    anchors.rightMargin: 45
                    anchors.verticalCenter: parent.verticalCenter
                    z: 2

                    Image {
                        anchors.centerIn: parent
                        width: parent.width - 2
                        height: parent.height - 2
                        source: "assets/ui/terminal.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            console.log("clicked terminal Obd2Screen")
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    onPressed: {
                        if (comPort.availablePorts.length > 0) {
                            comPortComboBox.popup.open()
                        }
                    }
                    z: 1
                }


                contentItem: Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: comPortComboBox.currentText
                    color: "white"
                    opacity: comPort.availablePorts.length > 0 ? 1 : 0.5
                    font.bold: true
                    font.pixelSize: 26
                }

                indicator: Item {}

                delegate: ItemDelegate {
                    width: comPortComboBox.width
                    height: 40
                    background: Rectangle { color: "transparent" }
                    contentItem: Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.bold: true
                        color: "white"
                        font.pixelSize: 20
                    }
                }

                popup: Popup {
                    width: comPortComboBox.width
                    implicitHeight: contentItem.implicitHeight
                    padding: 0
                    clip: true
                    focus: true
                    height: Math.min(contentHeight, 390)
                    background: Rectangle {
                        radius: 25
                        color: comPortComboBox.activeColor
                    }
                    contentItem: ListView {
                        clip: true
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        implicitHeight: contentHeight
                        model: comPortComboBox.popup.visible ? comPortComboBox.delegateModel : null
                        currentIndex: comPortComboBox.highlightedIndex
                        ScrollIndicator.vertical: ScrollIndicator {}
                        spacing: 0
                    }
                }

                onCurrentTextChanged: {
                    if (currentText !== "" && currentText !== "Нет доступных портов") {
                        if (comConnector.openPort(currentText)) {
                            console.log("Port opened successfully:", currentText)
                        } else {
                            console.log("Failed to open port:", currentText)
                        }
                    }
                }

                Connections {
                    target: comPort
                    function onAvailablePortsChanged() {
                        comPortComboBox.model = comPort.availablePorts.length > 0
                                                ? comPort.availablePorts
                                                : ["Нет доступных портов"]
                    }
                }
            }
        }
    }






    //Engine
        Text {
            text: "Engine"
            color: "white"
            font.pixelSize: 30
            font.bold: true
            anchors.top: parent.top
            anchors.topMargin: -2
            anchors.left: parent.left
            anchors.leftMargin: 15
        }
        Image {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 2
            anchors.leftMargin: 115
            width: 35
            height: 35
            source: "assets/ui/engine.png"
        }

        Rectangle {
            id:  engine_prm
            width: 465
            height: 260
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 40
            anchors.leftMargin: 15
            radius: 26
            color: "#221F1F"

            //power
            Image {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 10
                anchors.leftMargin: 10
                width: 50
                height: 50
                source: "assets/ui/power.png"
            }

            Slider {
                id: powerSlider
                from: 0
                to: 2000
                value: power
                stepSize: 1
                anchors.left: parent.left
                anchors.leftMargin: 70
                anchors.top: parent.top
                anchors.topMargin: 24
                width: 325
                height: 18
                topPadding: 9
                clip: false

                Text {
                    id: powerValueText
                    text: power.toString()
                    color: "#26C3F6"
                    font.pixelSize: 16
                    font.bold: true
                    anchors.top: parent.top
                    anchors.topMargin: -16
                    anchors.horizontalCenter: powerSlider.handle.horizontalCenter
                }

                background: Rectangle {
                    x: 0
                    y: powerSlider.topPadding + (powerSlider.availableHeight - height) / 2
                    implicitWidth: 100
                    implicitHeight: 8
                    width: powerSlider.availableWidth
                    height: implicitHeight
                    radius: 4
                    color: "#25334C"

                    Rectangle {
                        width: powerSlider.handle.x + powerSlider.handle.width / 2
                        height: parent.height
                        color: "#26C3F6"
                        radius: 4
                    }
                }

                handle: Rectangle {
                    x: powerSlider.leftPadding + powerSlider.visualPosition * powerSlider.availableWidth - width / 2
                    y: powerSlider.topPadding + (powerSlider.availableHeight - height) / 2
                    width: 15
                    height: 15
                    radius: 10
                    color: "#26C3F6"
                }

                onValueChanged: {
                    power = Math.round(value);
                }
            }

            Image {
                id: infoImage
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 16
                anchors.rightMargin: 18
                width: 40
                height: 40
                source: "assets/ui/info.png"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onEntered: {
                        powerInfo.visible = true
                        powerInfo.x = infoImage.x + mouseX + 15
                        powerInfo.y = infoImage.y + mouseY
                    }

                    onPositionChanged: (mouse) => {
                        powerInfo.x = infoImage.x + mouse.x + 15
                        powerInfo.y = infoImage.y + mouse.y
                    }

                    onExited: {
                        powerInfo.visible = false
                    }
                }
            }

            Rectangle {
                id: powerInfo
                width: 275
                height: 65
                color: "#1C1919"
                border.color: "#26C3F6"
                border.width: 2
                radius: 10
                visible: false

                Text {
                    text: qsTr("Этот параметр управляет\nмощностью двигателя,\nизмеряемой в лошадиных силах.")
                    color: "white"
                    font.pixelSize: 16
                    font.family: cleanerFont.name
                    wrapMode: Text.WordWrap
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            //fuel
            Image {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 77
                anchors.leftMargin: 10
                width: 47
                height: 47
                source: "assets/ui/fuel.png"
            }

            Slider {
                id: fuelSlider
                from: 0
                to: 100
                value: fuel
                stepSize: 1
                anchors.left: parent.left
                anchors.leftMargin: 70
                anchors.top: parent.top
                anchors.topMargin: 88
                width: 300
                height: 18
                topPadding: 9
                clip: false

                Text {
                    id: fuelValueText
                    text: fuel.toString() + "%"
                    color: "#26C3F6"
                    font.pixelSize: 16
                    font.bold: true
                    anchors.top: parent.top
                    anchors.topMargin: -16
                    anchors.horizontalCenter: fuelSlider.handle.horizontalCenter
                }

                background: Rectangle {
                    x: 0
                    y: fuelSlider.topPadding + (fuelSlider.availableHeight - height) / 2
                    implicitWidth: 100
                    implicitHeight: 8
                    width: fuelSlider.availableWidth
                    height: implicitHeight
                    radius: 4
                    color: "#25334C"

                    Rectangle {
                        width: fuelSlider.handle.x + fuelSlider.handle.width / 2
                        height: parent.height
                        color: "#26C3F6"
                        radius: 4
                    }
                }

                handle: Rectangle {
                    x: fuelSlider.leftPadding + fuelSlider.visualPosition * fuelSlider.availableWidth - width / 2
                    y: fuelSlider.topPadding + (fuelSlider.availableHeight - height) / 2
                    width: 15
                    height: 15
                    radius: 10
                    color: "#26C3F6"
                }

                onValueChanged: {
                    fuel = Math.round(value);
                }
            }

            Image {
                id: infoImage2
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 79
                anchors.rightMargin: 45
                width: 40
                height: 40
                source: "assets/ui/info.png"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onEntered: {
                        fuelInfo.visible = true
                        fuelInfo.x = infoImage2.x + mouseX + 15
                        fuelInfo.y = infoImage2.y + mouseY
                    }

                    onPositionChanged: (mouse) => {
                        fuelInfo.x = infoImage2.x + mouse.x + 15
                        fuelInfo.y = infoImage2.y + mouse.y
                    }

                    onExited: {
                        fuelInfo.visible = false
                    }
                }
            }

            Rectangle {
                id: fuelInfo
                width: 225
                height: 45
                color: "#1C1919"
                border.color: "#26C3F6"
                border.width: 2
                radius: 10
                visible: false

                Text {
                    text: qsTr("Этот параметр показывает\nтекущий % топлива.")
                    color: "white"
                    font.pixelSize: 16
                    font.family: cleanerFont.name
                    wrapMode: Text.WordWrap
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            //temp
            Image {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 140
                anchors.leftMargin: 7
                width: 50
                height: 50
                source: "assets/ui/temp.png"
            }

            Slider {
                id: tempSlider
                from: -100
                to: 100
                value: temp
                stepSize: 1
                anchors.left: parent.left
                anchors.leftMargin: 70
                anchors.top: parent.top
                anchors.topMargin: 151
                width: 275
                height: 18
                topPadding: 9
                clip: false

                Text {
                    id: tempValueText
                    text: temp.toString() + "°C"
                    color: "#26C3F6"
                    font.pixelSize: 16
                    font.bold: true
                    anchors.top: parent.top
                    anchors.topMargin: -16
                    anchors.horizontalCenter: tempSlider.handle.horizontalCenter
                }

                background: Rectangle {
                    x: 0
                    y: tempSlider.topPadding + (tempSlider.availableHeight - height) / 2
                    implicitWidth: 100
                    implicitHeight: 8
                    width: tempSlider.availableWidth
                    height: implicitHeight
                    radius: 4
                    color: "#25334C"

                    Rectangle {
                        width: tempSlider.handle.x + tempSlider.handle.width / 2
                        height: parent.height
                        color: "#26C3F6"
                        radius: 4
                    }
                }

                handle: Rectangle {
                    x: tempSlider.leftPadding + tempSlider.visualPosition * tempSlider.availableWidth - width / 2
                    y: tempSlider.topPadding + (tempSlider.availableHeight - height) / 2
                    width: 15
                    height: 15
                    radius: 10
                    color: "#26C3F6"
                }

                onValueChanged: {
                    temp = Math.round(value);
                }
            }

            Image {
                id: infoImage3
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 142
                anchors.rightMargin: 72
                width: 40
                height: 40
                source: "assets/ui/info.png"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onEntered: {
                        tempInfo.visible = true
                        tempInfo.x = infoImage3.x + mouseX + 15
                        tempInfo.y = infoImage3.y + mouseY
                    }

                    onPositionChanged: (mouse) => {
                        tempInfo.x = infoImage3.x + mouse.x + 15
                        tempInfo.y = infoImage3.y + mouse.y
                    }

                    onExited: {
                        tempInfo.visible = false
                    }
                }
            }

            Rectangle {
                id: tempInfo
                width: 225
                height: 45
                color: "#1C1919"
                border.color: "#26C3F6"
                border.width: 2
                radius: 10
                visible: false

                Text {
                    text: qsTr("Этот параметр показывает\nтемпературу двигателя.")
                    color: "white"
                    font.pixelSize: 16
                    font.family: cleanerFont.name
                    wrapMode: Text.WordWrap
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            //oil
            Image {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 200
                anchors.leftMargin: 12
                width: 50
                height: 50
                source: "assets/ui/oil.png"
            }

            Slider {
                id: oilSlider
                from: 0.0
                to: 10.0
                value: oilLevel
                stepSize: 0.1
                anchors.left: parent.left
                anchors.leftMargin: 70
                anchors.top: parent.top
                anchors.topMargin: 211
                width: 250
                height: 18
                topPadding: 9
                clip: false

                Text {
                    id: oilValueText
                    text: oilLevel.toFixed(1) + "L"
                    color: "#26C3F6"
                    font.pixelSize: 16
                    font.bold: true
                    anchors.top: parent.top
                    anchors.topMargin: -16
                    anchors.horizontalCenter: oilSlider.handle.horizontalCenter
                }

                background: Rectangle {
                    x: 0
                    y: oilSlider.topPadding + (oilSlider.availableHeight - height) / 2
                    implicitWidth: 100
                    implicitHeight: 8
                    width: oilSlider.availableWidth
                    height: implicitHeight
                    radius: 4
                    color: "#25334C"

                    Rectangle {
                        width: oilSlider.handle.x + oilSlider.handle.width / 2
                        height: parent.height
                        color: "#26C3F6"
                        radius: 4
                    }
                }

                handle: Rectangle {
                    x: oilSlider.leftPadding + oilSlider.visualPosition * oilSlider.availableWidth - width / 2
                    y: oilSlider.topPadding + (oilSlider.availableHeight - height) / 2
                    width: 15
                    height: 15
                    radius: 10
                    color: "#26C3F6"
                }

                onValueChanged: {
                    oilLevel = Math.round(value * 10) / 10;
                }
            }

            Image {
                id: infoImage4
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 202
                anchors.rightMargin: 99
                width: 40
                height: 40
                source: "assets/ui/info.png"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onEntered: {
                        oilInfo.visible = true
                        oilInfo.x = infoImage4.x + mouseX + 15
                        oilInfo.y = infoImage4.y + mouseY
                    }

                    onPositionChanged: (mouse) => {
                        oilInfo.x = infoImage4.x + mouse.x + 15
                        oilInfo.y = infoImage4.y + mouse.y
                    }

                    onExited: {
                        oilInfo.visible = false
                    }
                }
            }

            Rectangle {
                id: oilInfo
                width: 225
                height: 65
                color: "#1C1919"
                border.color: "#26C3F6"
                border.width: 2
                radius: 10
                visible: false

                Text {
                    text: qsTr("Этот параметр показывает\nуровень масла в\nдвигателе.")
                    color: "white"
                    font.pixelSize: 16
                    font.family: cleanerFont.name
                    wrapMode: Text.WordWrap
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }










    // Saloon
    Text {
        text: "Saloon"
        color: "white"
        font.pixelSize: 30
        font.bold: true
        anchors.top: engine_prm.bottom
        anchors.topMargin: -1
        anchors.left: parent.left
        anchors.leftMargin: 15
    }
    Image {
        anchors.top: engine_prm.bottom
        anchors.left: parent.left
        anchors.topMargin: 3
        anchors.leftMargin: 115
        width: 35
        height: 35
        source: "assets/ui/engine.png"
    }

    Rectangle {
        // id:  engine_prm
        width: 465
        height: 260
        anchors.top: engine_prm.bottom
        anchors.left: parent.left
        anchors.topMargin: 40
        anchors.leftMargin: 15
        radius: 26
        color: "#221F1F"

        //power
        // Image {
        //     anchors.top: parent.top
        //     anchors.left: parent.left
        //     anchors.topMargin: 10
        //     anchors.leftMargin: 10
        //     width: 50
        //     height: 50
        //     source: "assets/ui/power.png"
        // }

        // Slider {
        //     id: powerSlider
        //     from: 0
        //     to: 2000
        //     value: power
        //     stepSize: 1
        //     anchors.left: parent.left
        //     anchors.leftMargin: 70
        //     anchors.top: parent.top
        //     anchors.topMargin: 33
        //     width: 325
        //     height: 9

        //     Text {
        //         id: powerValueText
        //         text: power.toString()
        //         color: "#26C3F6"
        //         font.pixelSize: 16
        //         font.bold: true
        //         anchors.top: parent.top
        //         anchors.topMargin: -25
        //         anchors.horizontalCenter: powerSlider.handle.horizontalCenter
        //     }

        //     background: Rectangle {
        //         x: 0
        //         y: (powerSlider.availableHeight - height) / 2
        //         implicitWidth: 100
        //         implicitHeight: 8
        //         width: powerSlider.availableWidth
        //         height: implicitHeight
        //         radius: 4
        //         color: "#25334C"

        //         Rectangle {
        //             width: powerSlider.handle.x + powerSlider.handle.width / 2
        //             height: parent.height
        //             color: "#26C3F6"
        //             radius: 4
        //         }
        //     }

        //     handle: Rectangle {
        //         x: powerSlider.leftPadding + powerSlider.visualPosition * (powerSlider.availableWidth - width)
        //         y: powerSlider.topPadding + (powerSlider.availableHeight - height) / 2
        //         width: 15
        //         height: 15
        //         radius: 10
        //         color: "#26C3F6"
        //     }

        //     onValueChanged: {
        //         power = Math.round(value);
        //     }
        // }

        // Image {
        //     id: infoImage
        //     anchors.top: parent.top
        //     anchors.right: parent.right
        //     anchors.topMargin: 16
        //     anchors.rightMargin: 18
        //     width: 40
        //     height: 40
        //     source: "assets/ui/info.png"

        //     MouseArea {
        //         anchors.fill: parent
        //         cursorShape: Qt.PointingHandCursor
        //         hoverEnabled: true

        //         onEntered: {
        //             powerInfo.visible = true
        //             powerInfo.x = infoImage.x + mouseX + 15
        //             powerInfo.y = infoImage.y + mouseY
        //         }

        //         onPositionChanged: (mouse) => {
        //             powerInfo.x = infoImage.x + mouse.x + 15
        //             powerInfo.y = infoImage.y + mouse.y
        //         }

        //         onExited: {
        //             powerInfo.visible = false
        //         }
        //     }
        // }

        // Rectangle {
        //     id: powerInfo
        //     width: 275
        //     height: 65
        //     color: "#1C1919"
        //     border.color: "#26C3F6"
        //     border.width: 2
        //     radius: 10
        //     visible: false

        //     Text {
        //         text: qsTr("Этот параметр управляет\nмощностью двигателя,\nизмеряемой в лошадиных силах.")
        //         color: "white"
        //         font.pixelSize: 16
        //         font.family: cleanerFont.name
        //         wrapMode: Text.WordWrap
        //         anchors.centerIn: parent
        //         horizontalAlignment: Text.AlignHCenter
        //         verticalAlignment: Text.AlignVCenter
        //     }
        // }

        // //fuel
        // Image {
        //     anchors.top: parent.top
        //     anchors.left: parent.left
        //     anchors.topMargin: 77
        //     anchors.leftMargin: 10
        //     width: 47
        //     height: 47
        //     source: "assets/ui/fuel.png"
        // }

        // Slider {
        //     id: fuelSlider
        //     from: 0
        //     to: 100
        //     value: fuel
        //     stepSize: 1
        //     anchors.left: parent.left
        //     anchors.leftMargin: 70
        //     anchors.top: parent.top
        //     anchors.topMargin: 97
        //     width: 300
        //     height: 9

        //     Text {
        //         id: fuelValueText
        //         text: fuel.toString() + "%"
        //         color: "#26C3F6"
        //         font.pixelSize: 16
        //         font.bold: true
        //         anchors.top: parent.top
        //         anchors.topMargin: -25
        //         anchors.horizontalCenter: fuelSlider.handle.horizontalCenter
        //     }

        //     background: Rectangle {
        //         x: 0
        //         y: (fuelSlider.availableHeight - height) / 2
        //         implicitWidth: 100
        //         implicitHeight: 8
        //         width: fuelSlider.availableWidth
        //         height: implicitHeight
        //         radius: 4
        //         color: "#25334C"

        //         Rectangle {
        //             width: fuelSlider.handle.x + fuelSlider.handle.width / 2
        //             height: parent.height
        //             color: "#26C3F6"
        //             radius: 4
        //         }
        //     }

        //     handle: Rectangle {
        //         x: fuelSlider.leftPadding + fuelSlider.visualPosition * (fuelSlider.availableWidth - width)
        //         y: fuelSlider.topPadding + (fuelSlider.availableHeight - height) / 2
        //         width: 15
        //         height: 15
        //         radius: 10
        //         color: "#26C3F6"
        //     }

        //     onValueChanged: {
        //         fuel = Math.round(value);
        //     }
        // }

        // Image {
        //     id: infoImage2
        //     anchors.top: parent.top
        //     anchors.right: parent.right
        //     anchors.topMargin: 79
        //     anchors.rightMargin: 45
        //     width: 40
        //     height: 40
        //     source: "assets/ui/info.png"

        //     MouseArea {
        //         anchors.fill: parent
        //         cursorShape: Qt.PointingHandCursor
        //         hoverEnabled: true

        //         onEntered: {
        //             fuelInfo.visible = true
        //             fuelInfo.x = infoImage2.x + mouseX + 15
        //             fuelInfo.y = infoImage2.y + mouseY
        //         }

        //         onPositionChanged: (mouse) => {
        //             fuelInfo.x = infoImage2.x + mouse.x + 15
        //             fuelInfo.y = infoImage2.y + mouse.y
        //         }

        //         onExited: {
        //             fuelInfo.visible = false
        //         }
        //     }
        // }

        // Rectangle {
        //     id: fuelInfo
        //     width: 225
        //     height: 45
        //     color: "#1C1919"
        //     border.color: "#26C3F6"
        //     border.width: 2
        //     radius: 10
        //     visible: false

        //     Text {
        //         text: qsTr("Этот параметр показывает\nтекущий % топлива.")
        //         color: "white"
        //         font.pixelSize: 16
        //         font.family: cleanerFont.name
        //         wrapMode: Text.WordWrap
        //         anchors.centerIn: parent
        //         horizontalAlignment: Text.AlignHCenter
        //         verticalAlignment: Text.AlignVCenter
        //     }
        // }

        // //temp
        // Image {
        //     anchors.top: parent.top
        //     anchors.left: parent.left
        //     anchors.topMargin: 140
        //     anchors.leftMargin: 7
        //     width: 50
        //     height: 50
        //     source: "assets/ui/temp.png"
        // }

        // Slider {
        //     id: tempSlider
        //     from: -100
        //     to: 100
        //     value: temp
        //     stepSize: 1
        //     anchors.left: parent.left
        //     anchors.leftMargin: 70
        //     anchors.top: parent.top
        //     anchors.topMargin: 160
        //     width: 275
        //     height: 9

        //     Text {
        //         id: tempValueText
        //         text: temp.toString() + "°C"
        //         color: "#26C3F6"
        //         font.pixelSize: 16
        //         font.bold: true
        //         anchors.top: parent.top
        //         anchors.topMargin: -25
        //         anchors.horizontalCenter: tempSlider.handle.horizontalCenter
        //     }

        //     background: Rectangle {
        //         x: 0
        //         y: (tempSlider.availableHeight - height) / 2
        //         implicitWidth: 100
        //         implicitHeight: 8
        //         width: tempSlider.availableWidth
        //         height: implicitHeight
        //         radius: 4
        //         color: "#25334C"

        //         Rectangle {
        //             width: tempSlider.handle.x + tempSlider.handle.width / 2
        //             height: parent.height
        //             color: "#26C3F6"
        //             radius: 4
        //         }
        //     }

        //     handle: Rectangle {
        //         x: tempSlider.leftPadding + tempSlider.visualPosition * (tempSlider.availableWidth - width)
        //         y: tempSlider.topPadding + (tempSlider.availableHeight - height) / 2
        //         width: 15
        //         height: 15
        //         radius: 10
        //         color: "#26C3F6"
        //     }

        //     onValueChanged: {
        //         temp = Math.round(value);
        //     }
        // }

        // Image {
        //     id: infoImage3
        //     anchors.top: parent.top
        //     anchors.right: parent.right
        //     anchors.topMargin: 142
        //     anchors.rightMargin: 72
        //     width: 40
        //     height: 40
        //     source: "assets/ui/info.png"

        //     MouseArea {
        //         anchors.fill: parent
        //         cursorShape: Qt.PointingHandCursor
        //         hoverEnabled: true

        //         onEntered: {
        //             tempInfo.visible = true
        //             tempInfo.x = infoImage3.x + mouseX + 15
        //             tempInfo.y = infoImage3.y + mouseY
        //         }

        //         onPositionChanged: (mouse) => {
        //             tempInfo.x = infoImage3.x + mouse.x + 15
        //             tempInfo.y = infoImage3.y + mouse.y
        //         }

        //         onExited: {
        //             tempInfo.visible = false
        //         }
        //     }
        // }

        // Rectangle {
        //     id: tempInfo
        //     width: 225
        //     height: 45
        //     color: "#1C1919"
        //     border.color: "#26C3F6"
        //     border.width: 2
        //     radius: 10
        //     visible: false

        //     Text {
        //         text: qsTr("Этот параметр показывает\nтемпературу двигателя.")
        //         color: "white"
        //         font.pixelSize: 16
        //         font.family: cleanerFont.name
        //         wrapMode: Text.WordWrap
        //         anchors.centerIn: parent
        //         horizontalAlignment: Text.AlignHCenter
        //         verticalAlignment: Text.AlignVCenter
        //     }
        // }

        // //oil
        // Image {
        //     anchors.top: parent.top
        //     anchors.left: parent.left
        //     anchors.topMargin: 200
        //     anchors.leftMargin: 12
        //     width: 50
        //     height: 50
        //     source: "assets/ui/oil.png"
        // }

        // Slider {
        //     id: oilSlider
        //     from: 0.0
        //     to: 10.0
        //     value: oilLevel
        //     stepSize: 0.1
        //     anchors.left: parent.left
        //     anchors.leftMargin: 70
        //     anchors.top: parent.top
        //     anchors.topMargin: 220
        //     width: 250
        //     height: 9

        //     Text {
        //         id: oilValueText
        //         text: oilLevel.toFixed(1) + "L"
        //         color: "#26C3F6"
        //         font.pixelSize: 16
        //         font.bold: true
        //         anchors.top: parent.top
        //         anchors.topMargin: -25
        //         anchors.horizontalCenter: oilSlider.handle.horizontalCenter
        //     }

        //     background: Rectangle {
        //         x: 0
        //         y: (oilSlider.availableHeight - height) / 2
        //         implicitWidth: 100
        //         implicitHeight: 8
        //         width: oilSlider.availableWidth
        //         height: implicitHeight
        //         radius: 4
        //         color: "#25334C"

        //         Rectangle {
        //             width: oilSlider.handle.x + oilSlider.handle.width / 2
        //             height: parent.height
        //             color: "#26C3F6"
        //             radius: 4
        //         }
        //     }

        //     handle: Rectangle {
        //         x: oilSlider.leftPadding + oilSlider.visualPosition * (oilSlider.availableWidth - width)
        //         y: oilSlider.topPadding + (oilSlider.availableHeight - height) / 2
        //         width: 15
        //         height: 15
        //         radius: 10
        //         color: "#26C3F6"
        //     }

        //     onValueChanged: {
        //         oilLevel = Math.round(value * 10) / 10;
        //     }
        // }

        // Image {
        //     id: infoImage4
        //     anchors.top: parent.top
        //     anchors.right: parent.right
        //     anchors.topMargin: 202
        //     anchors.rightMargin: 99
        //     width: 40
        //     height: 40
        //     source: "assets/ui/info.png"

        //     MouseArea {
        //         anchors.fill: parent
        //         cursorShape: Qt.PointingHandCursor
        //         hoverEnabled: true

        //         onEntered: {
        //             oilInfo.visible = true
        //             oilInfo.x = infoImage4.x + mouseX + 15
        //             oilInfo.y = infoImage4.y + mouseY
        //         }

        //         onPositionChanged: (mouse) => {
        //             oilInfo.x = infoImage4.x + mouse.x + 15
        //             oilInfo.y = infoImage4.y + mouse.y
        //         }

        //         onExited: {
        //             oilInfo.visible = false
        //         }
        //     }
        // }

        // Rectangle {
        //     id: oilInfo
        //     width: 225
        //     height: 65
        //     color: "#1C1919"
        //     border.color: "#26C3F6"
        //     border.width: 2
        //     radius: 10
        //     visible: false

        //     Text {
        //         text: qsTr("Этот параметр показывает\nуровень масла в\nдвигателе.")
        //         color: "white"
        //         font.pixelSize: 16
        //         font.family: cleanerFont.name
        //         wrapMode: Text.WordWrap
        //         anchors.centerIn: parent
        //         horizontalAlignment: Text.AlignHCenter
        //         verticalAlignment: Text.AlignVCenter
        //     }
        // }
    }












    // Button {
    //     anchors.right: parent.right
    //     text: "Scan Ports"
    //     onClicked: comPort.scanPorts()
    // }

    // ComboBox {
    //     anchors.right: parent.right
    //     anchors.top: parent.top
    //     anchors.topMargin: 100
    //     id: comPortComboBox
    //     width: 200
    //     height: 40
    //     model: comPort.availablePorts

    //     delegate: Item {
    //         width: parent.width
    //         height: 40

    //         Rectangle {
    //             width: parent.width
    //             height: 40
    //             color: "lightblue"
    //             border.color: "gray"
    //             radius: 4

    //             Text {
    //                 anchors.centerIn: parent
    //                 text: modelData
    //             }

    //             MouseArea {
    //                 anchors.fill: parent
    //                 onClicked: {
    //                     var selectedPort = modelData;
    //                     if (comConnector.openPort(selectedPort)) {
    //                         console.log("Port opened successfully:", selectedPort);
    //                     } else {
    //                         console.log("Failed to open port:", selectedPort);
    //                     }
    //                 }
    //             }
    //         }
    //     }

    //     onActivated: function(index) {
    //         var selectedPort = model[index];
    //         if (comConnector.openPort(selectedPort)) {
    //             console.log("Port opened successfully:", selectedPort);
    //         } else {
    //             console.log("Failed to open port:", selectedPort);
    //         }
    //     }
    // }


    // Connections {
    //     target: comPort
    //     onAvailablePortsChanged: console.log("Ports updated:", comPort.availablePorts);
    // }

}
