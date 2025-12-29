import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Window {
    id: mainWindow
    width: 1920
    height: 720
    visible: true
    title: "Audi TT 3.2 V6 - Euro Spec (280 km/h)"
    color: "black"

    // --- MOCK DATA ---
    property int rpm: 0
    property int speed: 0
    property bool viewModeSport: false
    property bool accelerating: true

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

        // 2. MIDDEN SCHERM (V6 MONITOR)
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
                        text: "3.2 V6 QUATTRO"
                        color: "white"
                        font.pixelSize: 32
                        font.bold: true
                    }
                    // Hier kunnen we later olie-temp en versnelling (DSG) tonen
                    Text {
                        text: "DSG: D3"
                        color: "#cc0000"
                        font.pixelSize: 40
                        font.bold: true
                    }
                }
            }
        }

        // ============================================================
        // 3. DE TELLERS (Exact nagemaakt van foto)
        // ============================================================

        // -- RPM METER --
        AudiGaugeNonLinear {
            id: rpmGauge
            value: rpm
            label: "1/min x 1000"
            logoText: "TT"

            // De reeks van de foto: 0 tot 8
            numberArray: [0, 1, 2, 3, 4, 5, 6, 7, 8]

            isRedline: true
            redlineStartIndex: 6.5 // Rood begint halverwege 6 en 7

            width: 650
            height: 650
            y: 35
        }

        // -- SNELHEIDSMETER (DE COMPLEXE 280 VERSIE) --
        AudiGaugeNonLinear {
            id: speedGauge
            value: speed
            label: "km/h"

            // DE UNIEKE EUROPESE SCHAALVERDELING
            // Deel 1: Stappen van 10 (0-80)
            // Deel 2: Stappen van 20 (80-280)
            numberArray: [0, 10, 20, 30, 40, 50, 60, 70, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280]

            isRedline: false

            width: 650
            height: 650
            y: 35
        }

        // 4. STATES & ANIMATIE
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

        // 5. VIEW KNOP
        Button {
            text: "VIEW"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 30
            onClicked: viewModeSport = !viewModeSport
            background: Rectangle {
                color: "transparent"
                border.color: "white"
                radius: 4
            }
            contentItem: Text {
                text: parent.text
                color: "white"
                font.bold: true
                padding: 10
            }
        }
    }

    // --- SIMULATIE ---
    Timer {
        running: false
        repeat: true
        interval: 16
        onTriggered: {
            if (accelerating) {
                rpm += 45
                speed += 0.8
                if (rpm >= 7200)
                    accelerating = false
            } else {
                rpm -= 60
                speed -= 1.2
                if (rpm <= 800)
                    accelerating = true
            }
        }
    }

    // ============================================================
    // COMPONENT: SLIMME NON-LINEAIRE METER
    // ============================================================
    component AudiGaugeNonLinear: Item {
        property real value: 0
        property var numberArray: []
        property string label: ""
        property string logoText: ""
        property bool isRedline: false
        property real redlineStartIndex: 0 // Waar begint rood (op basis van index of waarde)

        // De hoek van de meter (van 7 uur tot 5 uur is ong 260 graden)
        property real startAngle: -130
        property real totalSweep: 260

        transformOrigin: Item.Center

        // 1. Digitaal Midden
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

        // 2. Cijfers en Streepjes (Dynamisch op basis van Array)
        Repeater {
            model: numberArray.length
            Item {
                anchors.fill: parent
                // Omdat de afstand tussen elk cijfer op de fysieke plaat gelijk is
                // (ook al is het sprongetje van waarde verschillend, bijv 10 vs 20),
                // kunnen we de hoek lineair verdelen over de *hoeveelheid* cijfers.
                property real anglePerStep: totalSweep / (numberArray.length - 1)
                rotation: startAngle + (index * anglePerStep)

                // Groot streepje bij het cijfer
                Rectangle {
                    width: 4
                    height: 20
                    color: "white"
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    antialiasing: true
                }

                // Het Cijfer zelf
                Text {
                    text: numberArray[index]
                    color: (isRedline
                            && index >= 6) ? "#cc0000" : "#aaaaaa" // Rood vanaf 6000 rpm
                    font.pixelSize: 26
                    font.bold: true
                    font.italic: true
                    font.family: "Arial"
                    anchors.top: parent.top
                    anchors.topMargin: 55
                    anchors.horizontalCenter: parent.horizontalCenter
                    rotation: -parent.rotation
                }

                // Klein tussen-streepje (Halverwege naar het volgende cijfer)
                // We tekenen dit niet bij het allerlaatste cijfer
                Rectangle {
                    visible: index < numberArray.length - 1
                    width: 2
                    height: 12
                    color: "white"
                    // Draai hem een halve stap verder
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

        // 3. Rode Boog (RPM Redline)
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
                    // Rood begint bij 6500 toeren.
                    // 6500 is index 6.5 in onze array van 9 stappen (0-8)
                    // Hoek berekening: Start + (indexFractie / totaalIndex * TotaalHoek)
                    startAngle: -8 // Even handmatig gefinetuned voor de look
                    sweepAngle: 48
                }
            }
        }

        // 4. De Slimme Naald
        Item {
            anchors.fill: parent

            // DE MAGIE: Deze functie zorgt dat de naald sneller/langzamer gaat
            // afhankelijk van waar hij op de schaal is (0-80 vs 80-280)
            function calculateRotation(val) {
                var arr = numberArray
                // Beveiliging voor min/max
                if (val <= arr[0])
                    return startAngle
                if (val >= arr[arr.length - 1])
                    return startAngle + totalSweep

                // Zoek tussen welke twee schaal-cijfers de waarde zit
                for (var i = 0; i < arr.length - 1; i++) {
                    var low = arr[i]
                    var high = arr[i + 1]

                    if (val >= low && val <= high) {
                        // Hoe ver zijn we tussen low en high? (0.0 tot 1.0)
                        var fraction = (val - low) / (high - low)

                        // Omdat elk cijfer op het scherm even ver uit elkaar staat,
                        // is de hoek per 'stap' in de array constant.
                        var anglePerIndex = totalSweep / (arr.length - 1)

                        // Positie = Start + (aantal hele stappen) + (fractie van huidige stap)
                        return startAngle + (i * anglePerIndex) + (fraction * anglePerIndex)
                    }
                }
                return startAngle
            }

            rotation: calculateRotation(value)

            Behavior on rotation {
                SmoothedAnimation {
                    velocity: 1500
                }
            }

            // De Tip (Naald indicator)
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
