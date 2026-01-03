import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: gauge
    width: 650
    height: 650

    property real value: 0
    property var numberArray: []
    property string label: ""
    property string logoText: ""
    property bool isRedline: false
    property real redlineStartIndex: 6.5

    // Inhoud in het midden
    property alias centerContent: centerContainer.children

    property real startAngle: -130
    property real totalSweep: 260

    // =================================================================
    // 1. ACHTERGROND RINGEN (Open & Glowing)
    // =================================================================
    Item {
        anchors.fill: parent

        // Hoofdring
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "transparent"
            border.color: "#ffffff"
            border.width: 2
            opacity: 0.15
        }

        // Binnenring
        Rectangle {
            width: parent.width - 40; height: parent.height - 40
            anchors.centerIn: parent
            radius: width / 2
            color: "transparent"
            border.color: "#ffffff"
            border.width: 1
            opacity: 0.1
        }

        // Glow effect
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#00ccff"
            shadowBlur: 0.8
            opacity: 0.5
        }
    }

    // =================================================================
    // 2. SCHAALVERDELING
    // =================================================================
    Repeater {
        model: gauge.numberArray.length
        Item {
            anchors.fill: parent
            property real anglePerStep: gauge.totalSweep / (gauge.numberArray.length - 1)
            rotation: gauge.startAngle + (index * anglePerStep)

            // Streepjes
            Rectangle {
                width: 4; height: 20
                color: (gauge.isRedline && index >= gauge.redlineStartIndex) ? "#cc0000" : "white"
                anchors.top: parent.top; anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                antialiasing: true
                border.color: "black"; border.width: 1
            }

            // Cijfers
            Text {
                text: gauge.isRedline ? gauge.numberArray[index] / 1000 : gauge.numberArray[index]
                color: (gauge.isRedline && index >= gauge.redlineStartIndex) ? "#cc0000" : "#ffffff"
                font.pixelSize: 32
                font.bold: true
                font.family: "Titillium Web"
                anchors.top: parent.top; anchors.topMargin: 55
                anchors.horizontalCenter: parent.horizontalCenter
                rotation: -parent.rotation
                style: Text.Outline; styleColor: "black"
            }
        }
    }

    // =================================================================
    // 3. REDLINE BOOG
    // =================================================================
    Shape {
        visible: gauge.isRedline
        anchors.fill: parent
        opacity: 0.9
        ShapePath {
            strokeColor: "#cc0000"; strokeWidth: 8
            fillColor: "transparent"; capStyle: ShapePath.FlatCap
            PathAngleArc {
                centerX: gauge.width / 2; centerY: gauge.height / 2
                radiusX: (gauge.width / 2) - 20; radiusY: (gauge.height / 2) - 20
                startAngle: -8; sweepAngle: 48.4
            }
        }
        layer.enabled: true
        layer.effect: MultiEffect { shadowEnabled: true; shadowColor: "#ff0000"; shadowBlur: 1.0 }
    }

    // =================================================================
    // 4. MIDDEN INHOUD
    // =================================================================
    Item {
        id: centerContainer
        anchors.centerIn: parent
        width: 250; height: 250
        z: 5
    }

    // Labels
    Text {
        text: gauge.label
        color: "#cccccc"
        font.pixelSize: 20; font.italic: true; font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom; anchors.bottomMargin: 160
        style: Text.Outline; styleColor: "black"
    }
    Text {
        text: gauge.logoText
        visible: gauge.logoText !== ""
        color: "white"
        font.pixelSize: 32; font.bold: true; font.italic: true
        style: Text.Outline; styleColor: "#cc0000"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top; anchors.topMargin: 180
        layer.enabled: true
        layer.effect: MultiEffect { shadowEnabled: true; shadowColor: "black"; shadowBlur: 0.5 }
    }

    // =================================================================
    // 5. DE NAALD (Aan de buitenkant)
    // =================================================================
    Item {
        anchors.fill: parent
        z: 10
        rotation: calculateRotation(gauge.value)
        Behavior on rotation { SmoothedAnimation { velocity: 2500 } }

        function calculateRotation(val) {
            var arr = gauge.numberArray
            if (val <= arr[0]) return gauge.startAngle
            if (val >= arr[arr.length - 1]) return gauge.startAngle + gauge.totalSweep
            for (var i = 0; i < arr.length - 1; i++) {
                var low = arr[i]; var high = arr[i + 1]
                if (val >= low && val <= high) {
                    var fraction = (val - low) / (high - low)
                    var anglePerIndex = gauge.totalSweep / (arr.length - 1)
                    return gauge.startAngle + (i * anglePerIndex) + (fraction * anglePerIndex)
                }
            }
            return gauge.startAngle
        }

        // De Pointer (Het rode blokje aan de rand)
        Rectangle {
            width: 14
            height: 35
            color: "#ff0000"
            radius: 2

            // Positie: Aan de bovenkant van de cirkel (de rand)
            anchors.top: parent.top
            anchors.topMargin: 12
            anchors.horizontalCenter: parent.horizontalCenter

            antialiasing: true

            // Glow Effect voor de pointer
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#ff0000" // Rode gloed
                shadowBlur: 1.0
                shadowVerticalOffset: 0
            }
        }
    }
}
