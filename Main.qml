import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
// import Audi_V6_Monitor // Verwijder of gebruik als je assets via QRC laadt

Window {
    id: mainWindow
    width: 1920
    height: 720
    visible: true
    title: "Audi Virtual Cockpit"
    color: "black"

    // Fonts laden
    FontLoader { id: fontRegular; source: "assets/Titillium_Web/TitilliumWeb-Regular.ttf" }
    FontLoader { id: fontBold; source: "assets/Titillium_Web/TitilliumWeb-Bold.ttf" }

    // Data
    property int currentRpm: rpmSlider.value
    property int currentSpeed: speedSlider.value
    property string currentGear: "3"
    property int engineTemp: 94
    property int range: 420
    property string selectedTab: "NAV"

    Item {
        id: container
        anchors.fill: parent

        // 1. ACHTERGROND
        InfoBackground {
            anchors.fill: parent
            activeTab: selectedTab
            oilTemp: engineTemp
            range: range
        }

        // 2. TELLERS (Nu volledig open!)
        // RPM
        AudiGauge {
            id: rpmGauge
            scale: 0.95
            anchors.verticalCenter: parent.verticalCenter
            x: 50

            value: currentRpm
            label: "1/min x 1000"
            logoText: "TT"
            numberArray: [0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000]
            isRedline: true; redlineStartIndex: 6.5

            // Versnelling zweeft nu in het midden
            centerContent: Text {
                text: currentGear
                color: "white"
                font.pixelSize: 120
                font.family: fontBold.name
                anchors.centerIn: parent

                // Dikke rand voor leesbaarheid op de kaart
                style: Text.Outline; styleColor: "black"
            }
        }

        // SNELHEID
        AudiGauge {
            id: speedGauge
            scale: 0.95
            anchors.verticalCenter: parent.verticalCenter
            x: parent.width - width - 50

            value: currentSpeed
            label: "km/h"
            numberArray: [0, 20, 40, 60, 80, 100, 120, 140, 170, 200, 240, 280]
            isRedline: false

            centerContent: Text {
                text: currentSpeed
                color: "white"
                font.pixelSize: 100
                font.family: fontBold.name
                anchors.centerIn: parent
                style: Text.Outline; styleColor: "black"
            }
        }

        // 3. MENU
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
            Text { text: "14:30"; color: "white"; font.pixelSize: 28; font.family: fontBold.name; style: Text.Outline; styleColor: "black" }
            Text { text: "+12.5°C"; color: "white"; font.pixelSize: 28; font.family: fontBold.name; style: Text.Outline; styleColor: "black" }
        }
    }

    // --- TEST SLIDERS ---
    Rectangle {
        width: 600; height: 60
        anchors.bottom: parent.bottom; anchors.left: parent.left
        color: "#111"; opacity: 0.0
        RowLayout {
            anchors.fill: parent; anchors.margins: 10
            Slider { id: rpmSlider; from: 0; to: 8000; value: 3200; Layout.fillWidth: true }
            Slider { id: speedSlider; from: 0; to: 280; value: 65; Layout.fillWidth: true }
        }
    }
}
