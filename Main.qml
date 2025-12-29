import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Window {
    width: 1920
    height: 720
    visible: true
    title: "Audi TT 8J - Manual Test"
    color: "#050505"

    // --- 1. AANGEPASTE DATA (Luistert nu naar de sliders) ---
    // Math.round zorgt voor hele getallen (geen 4200.53 toeren)
    property int rpm: Math.round(rpmSlider.value)
    property int speed: Math.round(speedSlider.value)

    // Logica blijft hetzelfde
    property bool intakePowerMode: rpm > 4200
    property bool exhaustLoud: rpm > 3500

    // --- ACHTERGROND ---
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "#1a1a1a"
            }
            GradientStop {
                position: 1.0
                color: "#000000"
            }
        }
    }

    // --- DE TELLERS (Blijft hetzelfde) ---
    RowLayout {
        anchors.centerIn: parent
        spacing: 80

        TTGauge {
            id: rpmGauge
            value: rpm
            maxValue: 8000
            label: "1/min x 1000"
            isRpm: true
        }

        // Het FIS scherm (Midden)
        Rectangle {
            Layout.preferredWidth: 400
            Layout.preferredHeight: 480
            color: "#1a0000"
            border.color: "#333333"
            border.width: 2
            radius: 6
            property string audiRed: "#ff3300"

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 15

                Text {
                    text: "MANUAL TEST"
                    color: "#ffcc00"
                    font.pixelSize: 22
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }
                Rectangle {
                    height: 2
                    width: 320
                    color: "#cc0000"
                }

                Column {
                    spacing: 5
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        text: "INTAKE RUNNER"
                        color: parent.parent.audiRed
                        font.pixelSize: 18
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        text: intakePowerMode ? "SHORT [POWER]" : "LONG [TORQUE]"
                        color: intakePowerMode ? "white" : parent.parent.audiRed
                        font.pixelSize: 26
                        font.bold: true
                        font.family: "Courier"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle {
                    height: 1
                    width: 200
                    color: "#cc0000"
                    Layout.alignment: Qt.AlignHCenter
                }
                Column {
                    spacing: 5
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        text: "EXHAUST FLAP"
                        color: parent.parent.audiRed
                        font.pixelSize: 18
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        text: exhaustLoud ? "OPEN" : "CLOSED"
                        color: exhaustLoud ? "white" : parent.parent.audiRed
                        font.pixelSize: 26
                        font.bold: true
                        font.family: "Courier"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }

        TTGauge {
            id: speedGauge
            value: speed
            maxValue: 280
            label: "km/h"
            isRpm: false
        }
    }

    // --- 2. HET TEST PANEEL (NIEUW) ---
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: 800
        height: 120
        color: "#222222" // Donkergrijs zodat je het ziet
        radius: 10
        border.color: "white"
        opacity: 0.9

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20

            // Slider voor RPM
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "RPM: " + rpm
                    color: "white"
                    font.bold: true
                    width: 80
                }
                Slider {
                    id: rpmSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 8000
                    value: 800 // Startwaarde
                }
            }

            // Slider voor Snelheid
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "KM/H: " + speed
                    color: "white"
                    font.bold: true
                    width: 80
                }
                Slider {
                    id: speedSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 280
                    value: 0
                }
            }
        }
    }

    // --- 3. DE GAUGE COMPONENT (Jouw gefixte versie) ---
    component TTGauge: Item {
        property real value: 0
        property real maxValue: 100
        property string label: ""
        property bool isRpm: false

        property real minAngle: -135
        property real maxAngle: 135

        width: 500
        height: 500

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "#000000"
            border.width: 12
            border.color: "#cccccc"
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: "#555555"
                }
                GradientStop {
                    position: 1.0
                    color: "#111111"
                }
            }
        }
        Rectangle {
            anchors.fill: parent
            anchors.margins: 14
            radius: width / 2
            color: "#080808"
        }

        Repeater {
            model: 9
            Item {
                anchors.fill: parent
                property real range: maxAngle - minAngle
                property real step: range / 8
                property real currentAngle: minAngle + (index * step)
                rotation: currentAngle

                Rectangle {
                    width: 6
                    height: 25
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 30
                    antialiasing: true
                }
                Text {
                    text: isRpm ? index : index * 35
                    color: "white"
                    font.pixelSize: 32
                    font.bold: true
                    font.italic: true
                    font.family: "Arial"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 65
                    rotation: -parent.rotation
                }
            }
        }

        Shape {
            visible: isRpm
            anchors.fill: parent
            ShapePath {
                strokeColor: "#cc0000"
                strokeWidth: 10
                fillColor: "transparent"
                capStyle: ShapePath.FlatCap
                PathAngleArc {
                    centerX: 250
                    centerY: 250
                    radiusX: 200
                    radiusY: 200
                    startAngle: 0
                    sweepAngle: 45
                }
            }
        }

        Item {
            anchors.fill: parent
            rotation: minAngle + (Math.min(
                                      value,
                                      maxValue) / maxValue) * (maxAngle - minAngle)
            Behavior on rotation {
                SmoothedAnimation {
                    velocity: 2000
                    easing.type: Easing.OutQuad
                }
            } // Iets sneller gezet

            Rectangle {
                width: 8
                height: 180
                color: "#ff0000"
                antialiasing: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                anchors.bottomMargin: -20
            }
        }

        Rectangle {
            width: 44
            height: 44
            radius: 22
            color: "#111111"
            border.color: "#666666"
            border.width: 2
            anchors.centerIn: parent
        }
        Text {
            text: label
            color: "#aaaaaa"
            font.italic: true
            font.pixelSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 110
        }
    }
}
