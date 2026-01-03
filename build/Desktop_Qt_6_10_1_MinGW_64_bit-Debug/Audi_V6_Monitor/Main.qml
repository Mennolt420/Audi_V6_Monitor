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
    title: "Audi Virtual Cockpit - OEM Spec"
    color: "black"

    // --- FONTS LADEN (Exacte paden uit je upload) ---
    FontLoader {
        id: audiFontNormal
        source: "assets/Audi_Type_Digital_20210706/Audi Type Digital/AudiType v4.03 TrueType OpenType/AudiType-Normal_4.03.ttf"
    }
    FontLoader {
        id: audiFontBold
        source: "assets/Audi_Type_Digital_20210706/Audi Type Digital/AudiType v4.03 TrueType OpenType/AudiType-Bold_4.03.ttf"
    }

    // Helper properties voor makkelijk gebruik
    property string fontMain: audiFontNormal.status
                              === FontLoader.Ready ? audiFontNormal.name : "Arial"
    property string fontBold: audiFontBold.status === FontLoader.Ready ? audiFontBold.name : "Arial"

    // --- DATA VARIABELEN ---
    property int currentRpm: rpmSlider.value
    property int currentSpeed: speedSlider.value

    property int engineTemp: 94
    property int coolTemp: 90
    property int fuelLevel: 65
    property int load: 34
    property double avgCons: 9.8

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

        // 1. ACHTERGROND & MAP
        InfoBackground {
            anchors.fill: parent
            activeTab: selectedTab
            oilTemp: engineTemp
            range: range
        }

        // 2. AUDI LOGO (Rings)
        // Staat bovenin, gecentreerd, onder de TopBar
        Image {
            source: "assets/Audi-Rings-Digital_RGB/Web_RGB/Audi_Rings_Standard/Audi_Rings_wh-RGB.png"
            width: 180
            fillMode: Image.PreserveAspectFit
            anchors.top: parent.top
            anchors.topMargin: 90 // Net onder het menu
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.8
            z: 5
        }

        // 3. TELLERS

        // -- LINKS: TOERENTELLER (Met Verbruik & Load) --
        AudiGauge {
            id: rpmGauge
            anchors.verticalCenter: parent.verticalCenter
            x: 20

            value: currentRpm
            label: "1/min x 1000"
            // We geven het Audi font door
            customFont: fontBold
            numberArray: [0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000]
            isRedline: true
            redlineStartIndex: 6.5

            // Satellietbalken
            leftValue1: Math.min(coolTemp, 120) / 120
            leftIcon1: "💧"
            leftColor1: coolTemp > 110 ? "#ff0000" : "white"
            leftValue2: Math.min(engineTemp, 130) / 130
            leftIcon2: "🌡️"
            leftColor2: engineTemp < 80 ? "#00ccff" : "white"
            rightValue1: throttlePos / 100
            rightIcon1: "T"
            rightColor1: "#00cc00"
            rightValue2: pedalPos / 100
            rightIcon2: "P"
            rightColor2: "#00ccff"

            // --- CLUSTER INHOUD ---
            centerContent: ColumnLayout {
                anchors.centerIn: parent
                spacing: -10

                // Grote RPM waarde
                Text {
                    text: currentRpm
                    color: "white"
                    font.pixelSize: 90
                    font.family: fontBold
                    Layout.alignment: Qt.AlignHCenter
                    style: Text.Outline
                    styleColor: "black"
                }

                // Info rij
                RowLayout {
                    spacing: 30
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 10

                    // Gemiddeld Verbruik
                    Column {
                        spacing: 0
                        Text {
                            text: "Ø L/100km"
                            color: "#aaa"
                            font.pixelSize: 13
                            font.family: fontMain
                            anchors.horizontalCenter: parent.horizontalCenter
                            style: Text.Outline
                            styleColor: "black"
                        }
                        Text {
                            text: avgCons.toFixed(1)
                            color: "white"
                            font.pixelSize: 24
                            font.family: fontBold
                            anchors.horizontalCenter: parent.horizontalCenter
                            style: Text.Outline
                            styleColor: "black"
                        }
                    }

                    Rectangle {
                        width: 1
                        height: 30
                        color: "#666"
                    }

                    // Motor Belasting
                    Column {
                        spacing: 0
                        Text {
                            text: "LOAD"
                            color: "#aaa"
                            font.pixelSize: 13
                            font.family: fontMain
                            anchors.horizontalCenter: parent.horizontalCenter
                            style: Text.Outline
                            styleColor: "black"
                        }
                        Text {
                            text: load + "%"
                            color: "white"
                            font.pixelSize: 24
                            font.family: fontBold
                            anchors.horizontalCenter: parent.horizontalCenter
                            style: Text.Outline
                            styleColor: "black"
                        }
                    }
                }
            }
        }

        // -- RECHTS: SNELHEID (Met Range & Trip) --
        AudiGauge {
            id: speedGauge
            anchors.verticalCenter: parent.verticalCenter
            x: parent.width - width - 20

            value: currentSpeed
            label: "km/h"
            customFont: fontBold
            numberArray: [0, 20, 40, 60, 80, 100, 120, 140, 170, 200, 240, 280]
            isRedline: false

            rightValue2: fuelLevel / 100
            rightIcon2: "⛽"
            rightColor2: fuelLevel < 15 ? "#ff0000" : "white"

            // --- CLUSTER INHOUD ---
            centerContent: ColumnLayout {
                anchors.centerIn: parent
                spacing: -10

                // Grote Snelheid
                Text {
                    text: currentSpeed
                    color: "white"
                    font.pixelSize: 110
                    font.family: fontBold
                    Layout.alignment: Qt.AlignHCenter
                    style: Text.Outline
                    styleColor: "black"
                }

                // Info Rij
                RowLayout {
                    spacing: 30
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 10

                    // Actieradius (Rechts, zoals gevraagd)
                    Column {
                        spacing: 0
                        Text {
                            text: "RANGE"
                            color: "#aaa"
                            font.pixelSize: 13
                            font.family: fontMain
                            anchors.horizontalCenter: parent.horizontalCenter
                            style: Text.Outline
                            styleColor: "black"
                        }
                        Text {
                            text: range + " km"
                            color: "#00ccff"
                            font.pixelSize: 24
                            font.family: fontBold
                            anchors.horizontalCenter: parent.horizontalCenter
                            style: Text.Outline
                            styleColor: "black"
                        }
                    }

                    Rectangle {
                        width: 1
                        height: 30
                        color: "#666"
                    }

                    // Dagtoerenteller
                    Column {
                        spacing: 0
                        Text {
                            text: "TRIP"
                            color: "#aaa"
                            font.pixelSize: 13
                            font.family: fontMain
                            anchors.horizontalCenter: parent.horizontalCenter
                            style: Text.Outline
                            styleColor: "black"
                        }
                        Text {
                            text: trip.toFixed(1)
                            color: "white"
                            font.pixelSize: 24
                            font.family: fontBold
                            anchors.horizontalCenter: parent.horizontalCenter
                            style: Text.Outline
                            styleColor: "black"
                        }
                    }
                }
            }
        }

        // 3. TOP MENU
        TopBar {
            width: parent.width
            anchors.top: parent.top
            activeTab: selectedTab
            // We kunnen font doorgeven als property indien TopBar aangepast wordt,
            // maar voor nu gebruikt TopBar zijn eigen font definitie (zie bestand 4).
            onTabClicked: name => {
                              selectedTab = name
                          }
        }

        // 4. ONDER BALK
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
                    font.family: fontBold
                    style: Text.Outline
                    styleColor: "black"
                }
                Text {
                    text: "+12.5°C"
                    color: "white"
                    font.pixelSize: 22
                    font.family: fontMain
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
                    text: "Total"
                    color: "#888"
                    font.pixelSize: 18
                    font.family: fontMain
                    style: Text.Outline
                    styleColor: "black"
                }
                Text {
                    text: odo + " km"
                    color: "white"
                    font.pixelSize: 22
                    font.family: fontBold
                    style: Text.Outline
                    styleColor: "black"
                }
            }
        }
    }

    // TEST PANEL
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
