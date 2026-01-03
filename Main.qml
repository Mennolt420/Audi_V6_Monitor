import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: mainWindow
    width: 1920
    height: 720
    visible: true
    title: "Audi TT 8J - Transparent Digital Dashboard"
    color: "black"

    // --- CENTRALE DATA OPSLAG ---
    property int currentRpm: rpmSlider.value
    property int currentSpeed: speedSlider.value
    property string currentGear: "3"
    property int engineTemp: 94
    property int range: 420
    property string selectedTab: "CAR"

    Item {
        id: container
        anchors.fill: parent

        // 1. ACHTERGROND & INFORMATIE (Ligt nu visueel 'in' de tellers)
        InfoBackground {
            anchors.fill: parent
            activeTab: selectedTab
            oilTemp: engineTemp
            range: range
        }

        // --- [VERWIJDERD] De zwarte 'gloed' cirkels zijn hier weggehaald ---

        // 2. TELLERS (Import uit AudiGauge.qml)
        // Ze zijn nu doorzichtig en regelen hun eigen leesbaarheid

        // -- RPM (Links) --
        AudiGauge {
            id: rpmGauge
            scale: 0.9
            anchors.verticalCenter: parent.verticalCenter
            x: 80

            value: currentRpm
            label: "1/min x 1000"
            logoText: "TT"
            numberArray: [0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000]
            isRedline: true; redlineStartIndex: 6.5

            centerContent: Text {
                text: currentGear
                color: "white"
                font.pixelSize: 100
                font.bold: true
                font.family: "Arial"
                anchors.centerIn: parent
                // Extra outline voor leesbaarheid
                style: Text.Outline; styleColor: "black"
            }
        }

        // -- SNELHEID (Rechts) --
        AudiGauge {
            id: speedGauge
            scale: 0.9
            anchors.verticalCenter: parent.verticalCenter
            x: parent.width - width - 80

            value: currentSpeed
            label: "km/h"
            numberArray: [0, 20, 40, 60, 80, 100, 120, 140, 170, 200, 240, 280]
            isRedline: false

            centerContent: Text {
                text: currentSpeed
                color: "white"
                font.pixelSize: 80
                font.bold: true
                font.family: "Arial"
                anchors.centerIn: parent
                // Extra outline voor leesbaarheid
                style: Text.Outline; styleColor: "black"
            }
        }

        // 3. MENU BALK
        TopBar {
            width: parent.width
            anchors.top: parent.top
            activeTab: selectedTab
            onTabClicked: (name) => { selectedTab = name }
        }

        // 4. ONDER BALK
        RowLayout {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 150
            Text { text: "14:30"; color: "white"; font.pixelSize: 28; font.bold: true; style: Text.Outline; styleColor: "black" }
            Text { text: "+12.5°C"; color: "white"; font.pixelSize: 28; font.bold: true; style: Text.Outline; styleColor: "black" }
        }
    }

    // --- TEST CONTROLS ---
    Rectangle {
        width: 600; height: 60
        anchors.bottom: parent.bottom; anchors.left: parent.left
        color: "#111"; opacity: 0.8
        RowLayout {
            anchors.fill: parent; anchors.margins: 10
            Slider { id: rpmSlider; from: 0; to: 8000; value: 0; Layout.fillWidth: true }
            Slider { id: speedSlider; from: 0; to: 280; value: 0; Layout.fillWidth: true }
        }
    }
}
