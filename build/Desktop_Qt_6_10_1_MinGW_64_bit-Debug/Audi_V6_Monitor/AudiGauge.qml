import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: gauge
    width: 750
    height: 750

    // Interne maatvoering
    readonly property real ringRadius: 290

    property real value: 0
    property var numberArray: []
    property string label: ""
    property string logoText: ""
    property bool isRedline: false
    property real redlineStartIndex: 6.5

    // Font property (wordt doorgegeven vanuit Main)
    property string customFont: "Arial"

    property alias centerContent: centerContainer.children
    property real startAngle: -130
    property real totalSweep: 260

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

    // --- SATELLIET BALKEN ---
    component SatBar: Item {
        property bool isRight: false
        property int stackIndex: 0
        property real val: 0.0
        property string icon: ""
        property color barColor: "white"
        visible: icon !== ""
        anchors.fill: parent
        readonly property real r: gauge.ringRadius + 15 + (stackIndex * 32)
        property real startAng: isRight ? 30 : 150
        property real swp: isRight ? -60 : 60

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
        Shape {
            anchors.fill: parent
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: barColor
                shadowBlur: 0.8
                opacity: 1.0
                paddingRect: Qt.rect(-20, -20, parent.width + 40,
                                     parent.height + 40)
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
        Text {
            text: icon
            color: barColor
            font.pixelSize: 20
            font.bold: true
            style: Text.Outline
            styleColor: "black"
            x: (width / 2) + (r + 28) * Math.cos(
                   (startAng + swp) * Math.PI / 180) - width / 2
            y: (height / 2) + (r + 28) * Math.sin(
                   (startAng + swp) * Math.PI / 180) - height / 2
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "black"
                shadowBlur: 0.5
            }
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

    // --- MAIN GAUGE ---
    Item {
        anchors.fill: parent
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
            Rectangle {
                width: 5
                height: 22
                color: (gauge.isRedline
                        && index >= gauge.redlineStartIndex) ? "#cc0000" : "white"
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
                font.family: gauge.customFont // GEBRUIK HET AUDI FONT
                y: (parent.height / 2) - ringRadius + 45
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
        width: 300
        height: 300
        z: 5
    }

    Text {
        text: gauge.label
        color: "#aaa"
        font.pixelSize: 20
        font.italic: true
        font.bold: true
        font.family: gauge.customFont
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (parent.height / 2) - 130
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
        font.family: gauge.customFont
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

    // Pointer
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
            width: 18
            height: 40
            color: "#ff0000"
            radius: 3
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
