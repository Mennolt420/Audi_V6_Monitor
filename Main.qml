import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Window {
    id: mainWindow
    width: 1920
    height: 720
    visible: true
    title: "Audi TT 3.2 V6 - Manual Test Mode"
    color: "black"

    // --- DATA (Nu gekoppeld aan de sliders!) ---
    property int rpm: rpmSlider.value
    property int speed: speedSlider.value
    property bool viewModeSport: false

    Item {
        id: container
        anchors.fill: parent

        // 1. ACHTERGROND
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: "#050505"
                }
                GradientStop {
                    position: 1.0
                    color: "#000000"
                }
            }
        }

        // 2. MIDDEN SCHERM
        Item {
            id: centerScreen
            width: 800
            height: 600
            anchors.centerIn: parent
            opacity: viewModeSport ? 1.0 : 0.0
            Behavior on opacity {
                NumberAnimation {
                    duration: 800
                }
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: 40
                color: "#111111"
                border.color: "#333333"
                radius: 15

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 20
                    Text {
                        text: "MANUAL TEST MODE"
                        color: "#ffcc00"
                        font.pixelSize: 32
                        font.bold: true
                    }
                    Text {
                        text: "RPM: " + rpm
                        color: "white"
                        font.pixelSize: 24
                    }
                    Text {
                        text: "SPD: " + speed + " km/h"
                        color: "white"
                        font.pixelSize: 24
                    }
                }
            }
        }

        // ============================================================
        // 3. DE TELLERS
        // ============================================================

        // -- RPM METER --
        AudiGaugeNonLinear {
            id: rpmGauge
            value: rpm
            label: "1/min x 1000"
            logoText: "TT"

            // VERANDER DIT: Gebruik echte toerentallen
            numberArray: [0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000]

            isRedline: true

            // Dit blijft 6.1 (we kijken naar de 6e positie in de rij)
            redlineStartIndex: 6.5

            width: 650
            height: 650
            y: 35
        }

        // -- SNELHEIDSMETER (280 KM/H) --
        AudiGaugeNonLinear {
            id: speedGauge
            value: speed
            label: "km/h"
            // De Europese schaalverdeling
            numberArray: [0, 10, 20, 30, 40, 50, 60, 70, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280]
            isRedline: false

            width: 650
            height: 650
            y: 35
        }

        // 4. ANIMATIE STATES
        states: [
            State {
                name: "classic"
                when: !viewModeSport
                PropertyChanges {
                    target: rpmGauge
                    x: 150
                    scale: 1.0
                }
                PropertyChanges {
                    target: speedGauge
                    x: 1120
                    scale: 1.0
                }
            },
            State {
                name: "sport"
                when: viewModeSport
                PropertyChanges {
                    target: rpmGauge
                    x: -50
                    scale: 0.6
                }
                PropertyChanges {
                    target: speedGauge
                    x: 1320
                    scale: 0.6
                }
            }
        ]
        transitions: Transition {
            NumberAnimation {
                properties: "x, scale"
                duration: 850
                easing.type: Easing.InOutQuart
            }
        }

        // 5. VIEW KNOP (Boven het testpaneel)
        Button {
            id: button
            text: "VIEW MODE"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 160 // Ruimte voor sliders
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: viewModeSport = !viewModeSport
            background: Rectangle {
                color: "transparent"
                border.color: "white"
                radius: 4
            }
            contentItem: Text {
                text: parent.text
                anchors.left: parent.left
                anchors.right: parent.right
                color: "white"
                font.bold: true
                padding: 10
            }
        }
    }

    // ============================================================
    // NIEUW: HET TEST PANEEL (Sliders)
    // ============================================================
    Rectangle {
        id: testPanel
        width: 1000
        height: 120
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
            anchors.margins: 20

            // RPM Slider
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "RPM (0-8000)"
                    color: "white"
                    font.bold: true
                    width: 100
                }
                Slider {
                    id: rpmSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 8000
                    stepSize: 10
                    value: 0
                }
                Text {
                    text: rpmSlider.value.toFixed(0)
                    color: "#ff3300"
                    font.bold: true
                    width: 50
                }
            }

            // Speed Slider
            RowLayout {
                id: rowLayout
                Layout.fillWidth: true
                Text {
                    text: "SPEED (0-280)"
                    color: "white"
                    font.bold: true
                    width: 100
                }
                Slider {
                    id: speedSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 280
                    stepSize: 1
                    value: 0
                }
                Text {
                    text: speedSlider.value.toFixed(0)
                    color: "#ff3300"
                    font.bold: true
                    width: 50
                }
            }
        }
    }

    // ============================================================
    // COMPONENT (Jouw werkende versie)
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

        // 1. Midden
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
                    width: 4
                    height: 20
                    color: (isRedline
                            && index >= redlineStartIndex) ? "#cc0000" : "white"
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    antialiasing: true
                }
                // Het Cijfer zelf
                Text {
                    // HIER ZIT DE FIX:
                    // Is het een RPM meter (isRedline)? Deel het getal dan door 1000.
                    // Zo wordt 1000 -> 1, 8000 -> 8.
                    text: isRedline ? numberArray[index] / 1000 : numberArray[index]

                    color: (isRedline
                            && index >= redlineStartIndex) ? "#cc0000" : "#aaaaaa"
                    font.pixelSize: 26
                    font.bold: true
                    font.italic: true
                    font.family: "Arial"
                    anchors.top: parent.top
                    anchors.topMargin: 55
                    anchors.horizontalCenter: parent.horizontalCenter
                    rotation: -parent.rotation
                }
                Rectangle {
                    visible: index < numberArray.length - 1
                    width: 2
                    height: 12
                    color: (isRedline
                            && index >= redlineStartIndex - 1) ? "#cc0000" : "#aaaaaa"
                    transform: Rotation {
                        origin.x: 0
                        origin.y: parent.height / 2
                        angle: anglePerStep / 2
                    }
                    anchors.top: parent.top
                    anchors.topMargin: 20
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
                strokeColor: "#cc0000"
                strokeWidth: 8
                fillColor: "transparent"
                capStyle: ShapePath.FlatCap
                PathAngleArc {
                    centerX: width / 2
                    centerY: height / 2
                    radiusX: (width / 2) - 20
                    radiusY: (height / 2) - 20
                    startAngle: -8
                    sweepAngle: 48.4
                }
            }
        }

        // 4. Naald
        Item {
            anchors.fill: parent

            function calculateRotation(val) {
                var arr = numberArray
                if (val <= arr[0])
                    return startAngle
                if (val >= arr[arr.length - 1])
                    return startAngle + totalSweep

                for (var i = 0; i < arr.length - 1; i++) {
                    var low = arr[i]
                    var high = arr[i + 1]
                    if (val >= low && val <= high) {
                        var fraction = (val - low) / (high - low)
                        var anglePerIndex = totalSweep / (arr.length - 1)
                        return startAngle + (i * anglePerIndex) + (fraction * anglePerIndex)
                    }
                }
                return startAngle
            }

            rotation: calculateRotation(value)

            // Zet deze animatie iets sneller voor directe respons op je muis
            Behavior on rotation {
                SmoothedAnimation {
                    velocity: 2000
                }
            }

            Rectangle {
                width: 14
                height: 35
                color: "#ff0000"
                radius: 2
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.horizontalCenter: parent.horizontalCenter
                layer.enabled: true
            }
        }
    }
}
