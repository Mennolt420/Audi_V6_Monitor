import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Effects

Window {
    id: mainWindow
    width: 1920
    height: 720
    visible: true
    title: "Audi Virtual Cockpit - Final Fix"
    color: "black"

    FontLoader {
        id: fontRegular
        source: "assets/Titillium_Web/TitilliumWeb-Regular.ttf"
    }
    FontLoader {
        id: fontBold
        source: "assets/Titillium_Web/TitilliumWeb-Bold.ttf"
    }

    // --- DATA (Dezelfde als voorheen) ---
    property int currentRpm: rpmSlider.value
    property int currentSpeed: speedSlider.value
    property string currentGear: "3"
    property int engineTemp: 94
    property int coolTemp: 90
    property int fuelLevel: 65
    property int pedalPos: pedalSlider.value
    property int throttlePos: throttleSlider.value
    property int range: 420
    property string selectedTab: "CAR"
    property string time: "14:30"
    property int odo: 145020
    property double trip: 214.5

    Item {
        id: container
        anchors.fill: parent

        InfoBackground {
            anchors.fill: parent
            activeTab: selectedTab
            oilTemp: engineTemp
            range: range
        }

        // --- TELLERS (Zonder Scale, Pure Positie) ---

        // -- RPM (Links) --
        AudiGauge {
            id: rpmGauge
            anchors.verticalCenter: parent.verticalCenter
            // Positie: De hele box (750px) staat links.
            // Door de negatieve marge of offset zetten we het hart op de juiste plek.
            x: 20 // 750 breed, dus hart zit op 375 + 20 = 395px van links. Perfect.

            value: currentRpm
            label: "1/min x 1000"
            numberArray: [0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000]
            isRedline: true
            redlineStartIndex: 6.5

            // Linker balken
            leftValue1: Math.min(coolTemp, 120) / 120
            leftIcon1: "💧"
            leftColor1: coolTemp > 110 ? "#ff0000" : "white"
            leftValue2: Math.min(engineTemp, 130) / 130
            leftIcon2: "🌡️"
            leftColor2: engineTemp < 80 ? "#00ccff" : "white"

            // Rechter balken
            rightValue1: throttlePos / 100
            rightIcon1: "T"
            rightColor1: "#00cc00"
            rightValue2: pedalPos / 100
            rightIcon2: "P"
            rightColor2: "#00ccff"

            centerContent: Text {
                text: currentGear
                color: "white"
                font.pixelSize: 120
                font.family: fontBold.name
                anchors.centerIn: parent
                style: Text.Outline
                styleColor: "black"
            }
        }

        // -- SNELHEID (Rechts) --
        AudiGauge {
            id: speedGauge
            anchors.verticalCenter: parent.verticalCenter
            x: parent.width - width - 20 // Symmetrisch rechts

            value: currentSpeed
            label: "km/h"
            numberArray: [0, 20, 40, 60, 80, 100, 120, 140, 170, 200, 240, 280]
            isRedline: false

            rightValue2: fuelLevel / 100
            rightIcon2: "⛽"
            rightColor2: fuelLevel < 15 ? "#ff0000" : "white"

            centerContent: Text {
                text: currentSpeed
                color: "white"
                font.pixelSize: 100
                font.family: fontBold.name
                anchors.centerIn: parent
                style: Text.Outline
                styleColor: "black"
            }
        }

        // 3. MENU BALK
        TopBar {
            width: parent.width
            anchors.top: parent.top
            activeTab: selectedTab
            onTabClicked: name => {
                              selectedTab = name
                          }
        }

        // 4. STATUS BALK
        Rectangle {
            width: parent.width
            height: 60
            anchors.bottom: parent.bottom
            color: "transparent"
            Rectangle {
                width: parent.width
                height: 1
                color: "#333"
                anchors.top: parent.top
            }
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 40
                anchors.rightMargin: 40
                Text {
                    text: time
                    color: "white"
                    font.pixelSize: 22
                    font.family: fontBold.name
                    style: Text.Outline
                    styleColor: "black"
                }
                Text {
                    text: "+12.5°C"
                    color: "white"
                    font.pixelSize: 22
                    font.family: fontRegular.name
                    style: Text.Outline
                    styleColor: "black"
                }
                Item {
                    Layout.fillWidth: true
                }
                Row {
                    spacing: 20
                    Text {
                        text: "🅿️"
                        font.pixelSize: 24
                        color: "#cc0000"
                    }
                    Text {
                        text: "💡"
                        font.pixelSize: 24
                        color: "#ffcc00"
                    }
                }
                Item {
                    Layout.fillWidth: true
                }
                Text {
                    text: "Trip " + trip.toFixed(1)
                    color: "#888"
                    font.pixelSize: 18
                    font.family: fontRegular.name
                    style: Text.Outline
                    styleColor: "black"
                }
                Text {
                    text: odo + " km"
                    color: "white"
                    font.pixelSize: 22
                    font.family: fontBold.name
                    style: Text.Outline
                    styleColor: "black"
                }
            }
        }
    }

    // Test Panel
    Rectangle {
        width: 600
        height: 120
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: "#111"
        opacity: 0.0
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.opacity = 0.9
            onExited: parent.opacity = 0.0
        }
        GridLayout {
            columns: 2
            anchors.fill: parent
            anchors.margins: 10
            Text {
                text: "RPM/SPD"
                color: "white"
            }
            RowLayout {
                Slider {
                    id: rpmSlider
                    from: 0
                    to: 8000
                    value: 3200
                    Layout.fillWidth: true
                }
                Slider {
                    id: speedSlider
                    from: 0
                    to: 280
                    value: 65
                    Layout.fillWidth: true
                }
            }
            Text {
                text: "PEDAL/THROT"
                color: "white"
            }
            RowLayout {
                Slider {
                    id: pedalSlider
                    from: 0
                    to: 100
                    value: 40
                    Layout.fillWidth: true
                }
                Slider {
                    id: throttleSlider
                    from: 0
                    to: 100
                    value: 35
                    Layout.fillWidth: true
                }
            }
        }
    }
}
