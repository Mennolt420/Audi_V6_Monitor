import QtQuick
import QtQuick.Shapes

Item {
    id: gauge
    width: 650
    height: 650

    property real value: 0
    property var numberArray: []
    property string label: ""
    property string logoText: ""
    property bool isRedline: false
    property real redlineStartIndex: 0
    property alias centerContent: centerContainer.children

    property real startAngle: -130
    property real totalSweep: 260

    // =================================================================
    // STRUCTUUR & LEESBAARHEID (Doorzichtig maar met contrast)
    // =================================================================

    // 1. Buitenste Ringen (Voor definitie van de klok)
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: "transparent"
        border.color: "#444444" // Iets lichter grijs voor zichtbaarheid op donkere kaart
        border.width: 4
        opacity: 0.8
    }

    // Subtiele binnenring
    Rectangle {
        width: parent.width - 40; height: parent.height - 40
        anchors.centerIn: parent
        radius: width / 2
        color: "transparent"
        border.color: "#222222"
        border.width: 2
        opacity: 0.6
    }

    // 2. Centrale Gloed (Zorgt dat de tekst in het midden leesbaar is)
    Rectangle {
        anchors.centerIn: parent
        width: 300; height: 300
        radius: 150
        // Radiaal verloop van zwart naar transparant
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#cc000000" } // 80% zwart in het hart
            GradientStop { position: 0.7; color: "#66000000" } // Deels transparant
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    // =================================================================
    // DE KLOK ONDERDELEN
    // =================================================================

    // 3. Schaalverdeling
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
            }

            // Cijfers (Met outline!)
            Text {
                text: gauge.isRedline ? gauge.numberArray[index] / 1000 : gauge.numberArray[index]
                color: (gauge.isRedline && index >= gauge.redlineStartIndex) ? "#cc0000" : "#ffffff"
                font.pixelSize: 28
                font.bold: true; font.family: "Arial"
                anchors.top: parent.top; anchors.topMargin: 55
                anchors.horizontalCenter: parent.horizontalCenter
                rotation: -parent.rotation

                // Zwarte rand om de letters (Vervangt DropShadow voor leesbaarheid)
                style: Text.Outline
                styleColor: "black"
            }
        }
    }

    // 4. Rode Boog (RPM Redline)
    Shape {
        visible: gauge.isRedline
        anchors.fill: parent
        opacity: 0.8
        ShapePath {
            strokeColor: "#cc0000"; strokeWidth: 8; fillColor: "transparent"; capStyle: ShapePath.FlatCap
            PathAngleArc {
                centerX: gauge.width / 2; centerY: gauge.height / 2
                radiusX: (gauge.width / 2) - 20; radiusY: (gauge.height / 2) - 20
                startAngle: -8; sweepAngle: 48.4
            }
        }
    }

    // 5. Midden Inhoud Container
    Item {
        id: centerContainer
        anchors.centerIn: parent
        width: 200; height: 200
        z: 5
    }

    // 6. Labels (TT logo, km/h, etc)
    Text {
        text: gauge.label
        color: "#cccccc"
        font.pixelSize: 24
        font.italic: true
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 160
        style: Text.Outline; styleColor: "black"
    }
    Text {
        text: gauge.logoText
        visible: gauge.logoText !== ""
        color: "white"
        font.pixelSize: 32
        font.bold: true; font.italic: true
        style: Text.Outline; styleColor: "#cc0000"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 180
    }

    // 7. De Naald
    Item {
        anchors.fill: parent
        z: 10

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

        rotation: calculateRotation(gauge.value)
        Behavior on rotation { SmoothedAnimation { velocity: 2000 } }

        // Schaduw van de naald (Simulatie met een zwart rechthoekje erachter)
        Rectangle {
            width: 14; height: 35
            color: "black"
            opacity: 0.5
            radius: 2
            anchors.top: parent.top; anchors.topMargin: 14 // Iets lager = schaduw effect
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 2 // Iets naar rechts = schaduw effect
        }

        // De echte naald
        Rectangle {
            width: 14; height: 35
            color: "#ff0000" // Audi rood
            radius: 2
            anchors.top: parent.top; anchors.topMargin: 12
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
