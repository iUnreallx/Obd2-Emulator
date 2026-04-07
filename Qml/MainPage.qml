import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Particles 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

Item {
    // ВАЖНО: Переименовали с root на mainPage, чтобы не конфликтовать с Main.qml
    id: mainPage
    anchors.fill: parent

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
        width: 310
        height: 85
        anchors.centerIn: parent
        id: blurBlock
        z: 3

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

        // --- ДОБАВИЛИ ТЕКСТ И КНОПКУ ---

        Text {
            anchors.centerIn: parent
            text: "START"
            color: "white"
            // Берем шрифт cleanerFont, который ты уже загрузил в Main.qml!
            font.family: cleanerFont.name
            font.pixelSize: 32
            font.bold: true
            font.letterSpacing: 2
            z: 4 // Текст должен быть поверх блюра
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor // Чтобы при наведении курсор менялся на палец

            onClicked: {
                // Обращаемся к id: root из Main.qml и дергаем его функцию
                root.changePage("Obd2Screen.qml")
            }
        }
    }
}
