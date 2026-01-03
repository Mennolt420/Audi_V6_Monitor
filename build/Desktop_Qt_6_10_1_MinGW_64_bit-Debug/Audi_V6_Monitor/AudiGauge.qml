import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: gauge
    // We maken de container groot genoeg voor de teller ÉN de balken eromheen
    width: 750
    height: 750

    // --- CONFIGURATIE ---
    // Dit is de straal van de HOOFDRING.
    // 290 * 2 = 580px diameter (past makkelijk in 720px hoogte + balken)
    readonly property real ringRadius: 290

    property real value: 0
    property var numberArray: []
    property string label: ""
    property string logoText: ""
    property bool isRedline: false
    property real redlineStartIndex: 6.5
    property alias centerContent: centerContainer.children

    property real startAngle: -130
    property real totalSweep: 260

    // --- SATELLIET CONFIG ---
    property real leftValue1: 0
    property string leftIcon1: ""
    property color leftColor1: "#ffffff"
    property real leftValue2: 0
    property string leftIcon2: ""
    property color leftColor2: "#ffffff"
    property real rightValue1: 0
    property string rightIcon1: ""
    property color rightColor1: "#ffffff"
    property real rightValue2: 0
    property string rightIcon2: ""
    property color rightColor2: "#ffffff"

    // =================================================================
    // SATELLIET BALKEN (Strakker gepositioneerd)
    // =================================================================
    component SatBar: Item {
        property bool isRight: false
        property int stackIndex: 0
        property real val: 0.0
        property string icon: ""
        property color barColor: "white"

        visible: icon !== ""
        anchors.fill: parent

        // Radius berekening: Ring + afstand
        // Index 0 (binnen): 290 + 15 = 305
        // Index 1 (buiten): 290 + 15 + 32 = 337
        readonly property real r: gauge.ringRadius + 15 + (stackIndex * 32)

        property real startAng: isRight ? 30 : 150
        property real swp: isRight ? -60 : 60

        // Achtergrond
        Shape {
            anchors.fill: parent
            ShapePath {
                strokeColor: "#222"
                strokeWidth: 16
                fillColor: "transparent"
                capStyle: ShapePath.FlatCap
                PathAngleArc {
                    centerX: width / 2
                    centerY: height / 2
                    radiusX: r
                    radiusY: r
                    startAngle: startAng
                    sweepAngle: swp
                }
            }
        }

        // Waarde + Glow
        Shape {
            anchors.fill: parent
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: barColor
                shadowBlur: 1.0
                opacity: 1.0
            }
            ShapePath {
                strokeColor: barColor
                strokeWidth: 12
                fillColor: "transparent"
                capStyle: ShapePath.FlatCap
                PathAngleArc {
                    centerX: width / 2
                    centerY: height / 2
                    radiusX: r
                    radiusY: r
                    startAngle: startAng
                    sweepAngle: swp * val
                }
            }
        }

        // Icoon
        Text {
            text: icon
            color: "#fff"
            font.pixelSize: 20
            font.bold: true
            style: Text.Outline
            styleColor: "black"
            x: (width / 2) + (r + 28) * Math.cos(
                   (startAng + swp) * Math.PI / 180) - width / 2
            y: (height / 2) + (r + 28) * Math.sin(
                   (startAng + swp) * Math.PI / 180) - height / 2
        }
    }

    SatBar {
        isRight: false
        stackIndex: 0
        val: leftValue1
        icon: leftIcon1
        barColor: leftColor1
    }
    SatBar {
        isRight: false
        stackIndex: 1
        val: leftValue2
        icon: leftIcon2
        barColor: leftColor2
    }
    SatBar {
        isRight: true
        stackIndex: 0
        val: rightValue1
        icon: rightIcon1
        barColor: rightColor1
    }
    SatBar {
        isRight: true
        stackIndex: 1
        val: rightValue2
        icon: rightIcon2
        barColor: rightColor2
    }

    // =================================================================
    // DE HOOFD TELLER
    // =================================================================
    Item {
        anchors.fill: parent

        // Hoofdring
        Rectangle {
            width: ringRadius * 2
            height: ringRadius * 2
            anchors.centerIn: parent
            radius: width / 2
            color: "transparent"
            border.color: "#ffffff"
            border.width: 3
            opacity: 0.2
        }
        // Binnenring
        Rectangle {
            width: (ringRadius - 20) * 2
            height: (ringRadius - 20) * 2
            anchors.centerIn: parent
            radius: width / 2
            color: "transparent"
            border.color: "#ffffff"
            border.width: 1
            opacity: 0.1
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#00ccff"
            shadowBlur: 1.0
            opacity: 0.5
        }
    }

    Repeater {
        model: gauge.numberArray.length
        Item {
            anchors.fill: parent
            property real anglePerStep: gauge.totalSweep / (gauge.numberArray.length - 1)
            rotation: gauge.startAngle + (index * anglePerStep)

            // Positie aanpassen aan nieuwe ringRadius
            Rectangle {
                width: 4
                height: 20
                color: (gauge.isRedline
                        && index >= gauge.redlineStartIndex) ? "#cc0000" : "white"
                // y positie: Center (height/2) - Radius
                y: (parent.height / 2) - ringRadius + 5
                anchors.horizontalCenter: parent.horizontalCenter
                antialiasing: true
                border.color: "black"
                border.width: 1
            }
            Text {
                text: gauge.isRedline ? gauge.numberArray[index] / 1000 : gauge.numberArray[index]
                color: (gauge.isRedline
                        && index >= gauge.redlineStartIndex) ? "#cc0000" : "#ffffff"
                font.pixelSize: 32
                font.bold: true
                font.family: "Titillium Web"
                // Tekst iets verder naar binnen
                y: (parent.height / 2) - ringRadius + 40
                anchors.horizontalCenter: parent.horizontalCenter
                rotation: -parent.rotation
                style: Text.Outline
                styleColor: "black"
            }
        }
    }

    Shape {
        visible: gauge.isRedline
        anchors.fill: parent
        opacity: 0.9
        ShapePath {
            strokeColor: "#cc0000"
            strokeWidth: 8
            fillColor: "transparent"
            capStyle: ShapePath.FlatCap
            PathAngleArc {
                centerX: width / 2
                centerY: height / 2
                radiusX: ringRadius - 20
                radiusY: ringRadius - 20
                startAngle: -8
                sweepAngle: 48.4
            }
        }
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#ff0000"
            shadowBlur: 1.0
        }
    }

    Item {
        id: centerContainer
        anchors.centerIn: parent
        width: 250
        height: 250
        z: 5
    }

    Text {
        text: gauge.label
        color: "#aaa"
        font.pixelSize: 20
        font.italic: true
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (parent.height / 2) - 130 // Relatief aan midden
        style: Text.Outline
        styleColor: "black"
    }
    Text {
        text: gauge.logoText
        visible: gauge.logoText !== ""
        color: "white"
        font.pixelSize: 32
        font.bold: true
        font.italic: true
        style: Text.Outline
        styleColor: "#cc0000"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: (parent.height / 2) + 120
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "black"
            shadowBlur: 0.5
        }
    }

    // Pointer Naald
    Item {
        anchors.fill: parent
        z: 10
        rotation: calculateRotation(gauge.value)
        Behavior on rotation {
            SmoothedAnimation {
                velocity: 2500
            }
        }
        function calculateRotation(val) {
            /* ... zelfde logica ... */
            var arr = gauge.numberArray
            if (val <= arr[0])
                return gauge.startAngle
            if (val >= arr[arr.length - 1])
                return gauge.startAngle + gauge.totalSweep
            for (var i = 0; i < arr.length - 1; i++) {
                var low = arr[i]
                var high = arr[i + 1]
                if (val >= low && val <= high) {
                    var fraction = (val - low) / (high - low)
                    var anglePerIndex = gauge.totalSweep / (arr.length - 1)
                    return gauge.startAngle + (i * anglePerIndex) + (fraction * anglePerIndex)
                }
            }
            return gauge.startAngle
        }

        Rectangle {
            width: 16
            height: 35
            color: "#ff0000"
            radius: 2
            // Positie op de rand van de ring
            y: (parent.height / 2) - ringRadius - 10
            anchors.horizontalCenter: parent.horizontalCenter
            antialiasing: true
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#ff0000"
                shadowBlur: 1.0
            }
        }
    }
}
