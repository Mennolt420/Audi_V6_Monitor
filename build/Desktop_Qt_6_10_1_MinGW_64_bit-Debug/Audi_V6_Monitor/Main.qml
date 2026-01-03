import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Window {
    id: mainWindow
    width: 1920
    height: 720
    visible: true
    title: "Audi TT 3.2 V6 - Digital Cockpit"
    color: "black"

    // --- DATA VARIABELEN (Gekoppeld aan sliders voor testen) ---
    property int rpm: rpmSlider.value
    property int speed: speedSlider.value

    // Voorbeeld data (dit zou later uit je CAN-bus komen)
    property string currentTime: "14:30"
    property string currentDate: "ZA 3 JAN"
    property int oilTemp: 92
    property int coolTemp: 90
    property int range: 420

    Item {
        id: container
        anchors.fill: parent

        // ============================================================
        // 1. DE INFORMATIE ACHTERGROND (Vult nu alles)
        // ============================================================
        Rectangle {
            id: infoLayer
            anchors.fill: parent
            color: "#050505" // Zeer donkergrijs, bijna zwart

            // Een subtiel verloopje voor diepte
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#1a1a1a" }
                GradientStop { position: 0.2; color: "#050505" }
                GradientStop { position: 1.0; color: "#000000" }
            }

            // --- A. MEDIA / NAVIGATIE VAK (Het grote middenstuk) ---
            Rectangle {
                width: 700
                height: 400
                anchors.centerIn: parent
                color: "transparent"

                // Placeholder voor Navigatie of Album Art
                Text {
                    anchors.centerIn: parent
                    text: "No Media Playing"
                    color: "#333333"
                    font.pixelSize: 40
                    font.bold: true
                    font.family: "Arial"
                }

                // Sierlijnen om het middenvak
                Rectangle { height: 1; width: parent.width; color: "#333333"; anchors.top: parent.top }
                Rectangle { height: 1; width: parent.width; color: "#333333"; anchors.bottom: parent.bottom }
            }

            // --- B. TOP BAR (Datum, Tijd, Temp) ---
            RowLayout {
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 150

                Text {
                    text: currentDate
                    color: "#aaaaaa"
                    font.pixelSize: 24
                    font.bold: true
                }
                Text {
                    text: currentTime
                    color: "white"
                    font.pixelSize: 32
                    font.bold: true
                }
                Text {
                    text: "12.5°C"
                    color: "#aaaaaa"
                    font.pixelSize: 24
                    font.bold: true
                }
            }

            // --- C. BOTTOM INFO (Essentiele V6 data) ---
            RowLayout {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 160 // Boven de test sliders blijven
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 80

                // Olie Temperatuur
                Column {
                    spacing: 5
                    Text { text: "OIL"; color: "#888888"; font.pixelSize: 16; anchors.horizontalCenter: parent.horizontalCenter }
                    Text { text: oilTemp + "°C"; color: "white"; font.pixelSize: 24; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                }

                // Brandstof Bereik
                Column {
                    spacing: 5
                    Text { text: "RANGE"; color: "#888888"; font.pixelSize: 16; anchors.horizontalCenter: parent.horizontalCenter }
                    Text { text: range + " km"; color: "white"; font.pixelSize: 24; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                }

                // Koelvloeistof
                Column {
                    spacing: 5
                    Text { text: "COOLANT"; color: "#888888"; font.pixelSize: 16; anchors.horizontalCenter: parent.horizontalCenter }
                    Text { text: coolTemp + "°C"; color: "white"; font.pixelSize: 24; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                }
            }
        }

        // ============================================================
        // 2. DE TELLERS (Over de info laag heen getekend)
        // ============================================================

        // -- RPM METER (Links) --
        AudiGaugeNonLinear {
            id: rpmGauge
            value: rpm
            label: "1/min x 1000"
            logoText: "TT"
            numberArray: [0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000]
            isRedline: true
            redlineStartIndex: 6.5

            // Vaste positie en schaal
            scale: 0.85
            anchors.verticalCenter: parent.verticalCenter
            x: 50 // Linkerkant
        }

        // -- SNELHEIDSMETER (Rechts) --
        AudiGaugeNonLinear {
            id: speedGauge
            value: speed
            label: "km/h"
            numberArray: [0, 10, 20, 30, 40, 50, 60, 70, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280]
            isRedline: false

            // Vaste positie en schaal
            scale: 0.85
            anchors.verticalCenter: parent.verticalCenter
            x: parent.width - width - 50 // Rechterkant
        }
    }

    // ============================================================
    // TEST PANEEL (Sliders - Blijft behouden voor testen)
    // ============================================================
    Rectangle {
        id: testPanel
        width: 1000
        height: 100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#222222"
        radius: 10
        border.color: "#555555"
        border.width: 2
        opacity: 0.9

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10

            // RPM Slider
            RowLayout {
                Layout.fillWidth: true
                Text { text: "RPM"; color: "white"; font.bold: true; width: 60 }
                Slider {
                    id: rpmSlider
                    Layout.fillWidth: true
                    from: 0; to: 8000; stepSize: 10; value: 0
                }
                Text { text: rpmSlider.value.toFixed(0); color: "#ff3300"; width: 40 }
            }

            // Speed Slider
            RowLayout {
                Layout.fillWidth: true
                Text { text: "SPD"; color: "white"; font.bold: true; width: 60 }
                Slider {
                    id: speedSlider
                    Layout.fillWidth: true
                    from: 0; to: 280; stepSize: 1; value: 0
                }
                Text { text: speedSlider.value.toFixed(0); color: "#ff3300"; width: 40 }
            }
        }
    }

    // ============================================================
    // COMPONENT: Audi Gauge (Ongewijzigd)
    // ============================================================
    component AudiGaugeNonLinear: Item {
        property real value: 0
        property var numberArray: []
        property string label: ""
        property string logoText: ""
        property bool isRedline: false
        property real redlineStartIndex: 0

        property real startAngle: -130
        property real totalSweep: 260

        transformOrigin: Item.Center
        width: 650
        height: 650

        // 1. Midden Tekst
        Column {
            anchors.centerIn: parent
            Text {
                text: Math.round(value)
                color: "white"
                font.pixelSize: 110
                font.bold: true
                font.family: "Arial"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: label
                color: "#888888"
                font.pixelSize: 24
                font.italic: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: logoText
                visible: logoText !== ""
                color: "white"
                font.pixelSize: 32
                font.bold: true
                font.italic: true
                style: Text.Outline
                styleColor: "#cc0000"
                anchors.horizontalCenter: parent.horizontalCenter
                topPadding: 10
            }
        }

        // 2. Schaalverdeling
        Repeater {
            model: numberArray.length
            Item {
                anchors.fill: parent
                property real anglePerStep: totalSweep / (numberArray.length - 1)
                rotation: startAngle + (index * anglePerStep)

                Rectangle {
                    width: 4; height: 20
                    color: (isRedline && index >= redlineStartIndex) ? "#cc0000" : "white"
                    anchors.top: parent.top; anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    antialiasing: true
                }
                Text {
                    text: isRedline ? numberArray[index] / 1000 : numberArray[index]
                    color: (isRedline && index >= redlineStartIndex) ? "#cc0000" : "#aaaaaa"
                    font.pixelSize: 26
                    font.bold: true; font.italic: true; font.family: "Arial"
                    anchors.top: parent.top; anchors.topMargin: 55
                    anchors.horizontalCenter: parent.horizontalCenter
                    rotation: -parent.rotation
                }
                Rectangle {
                    visible: index < numberArray.length - 1
                    width: 2; height: 12
                    color: (isRedline && index >= redlineStartIndex - 1) ? "#cc0000" : "#aaaaaa"
                    transform: Rotation { origin.x: 0; origin.y: parent.height / 2; angle: anglePerStep / 2 }
                    anchors.top: parent.top; anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // 3. Rode Boog
        Shape {
            visible: isRedline
            anchors.fill: parent
            opacity: 0.8
            ShapePath {
                strokeColor: "#cc0000"; strokeWidth: 8; fillColor: "transparent"; capStyle: ShapePath.FlatCap
                PathAngleArc {
                    centerX: width / 2; centerY: height / 2
                    radiusX: (width / 2) - 20; radiusY: (height / 2) - 20
                    startAngle: -8; sweepAngle: 48.4
                }
            }
        }

        // 4. Naald
        Item {
            anchors.fill: parent
            function calculateRotation(val) {
                var arr = numberArray
                if (val <= arr[0]) return startAngle
                if (val >= arr[arr.length - 1]) return startAngle + totalSweep
                for (var i = 0; i < arr.length - 1; i++) {
                    var low = arr[i]; var high = arr[i + 1]
                    if (val >= low && val <= high) {
                        var fraction = (val - low) / (high - low)
                        var anglePerIndex = totalSweep / (arr.length - 1)
                        return startAngle + (i * anglePerIndex) + (fraction * anglePerIndex)
                    }
                }
                return startAngle
            }
            rotation: calculateRotation(value)
            Behavior on rotation { SmoothedAnimation { velocity: 2000 } }

            Rectangle {
                width: 14; height: 35
                color: "#ff0000"
                radius: 2
                anchors.top: parent.top; anchors.topMargin: 12
                anchors.horizontalCenter: parent.horizontalCenter
                layer.enabled: true
            }
        }
    }
}
