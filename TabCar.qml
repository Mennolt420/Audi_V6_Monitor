import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: root
    property int oilTemp: 0
    property int range: 0

    // G-Force Simulatie
    property real gX: Math.sin(Date.now() / 1000) * 0.5
    property real gY: Math.cos(Date.now() / 1300) * 0.3

    // Periodieke timer voor animatie (alleen voor show, later aan sensors koppelen)
    Timer { interval: 16; running: true; repeat: true; onTriggered: { root.gX = Math.sin(Date.now() / 800) * 0.6; } }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "G-METER"
            color: "#ffffff"; font.bold: true; font.pixelSize: 20
            Layout.alignment: Qt.AlignHCenter
            style: Text.Outline; styleColor: "black"
        }

        // De G-Force Cirkel
        Item {
            width: 300; height: 300
            Layout.alignment: Qt.AlignHCenter

            // Achtergrond Cirkels (Het doelwit)
            Shape {
                anchors.fill: parent
                layer.enabled: true
                layer.effect: MultiEffect { shadowEnabled: true; shadowColor: "#00ccff"; shadowBlur: 0.5; opacity: 0.5 }

                ShapePath {
                    strokeColor: "#444"; strokeWidth: 2; fillColor: "#aa000000"
                    PathAngleArc { centerX: 150; centerY: 150; radiusX: 140; radiusY: 140; startAngle: 0; sweepAngle: 360 }
                }
                ShapePath { // Binnenring 1
                    strokeColor: "#444"; strokeWidth: 1; fillColor: "transparent"
                    PathAngleArc { centerX: 150; centerY: 150; radiusX: 90; radiusY: 90; startAngle: 0; sweepAngle: 360 }
                }
                ShapePath { // Binnenring 2
                    strokeColor: "#444"; strokeWidth: 1; fillColor: "transparent"
                    PathAngleArc { centerX: 150; centerY: 150; radiusX: 40; radiusY: 40; startAngle: 0; sweepAngle: 360 }
                }
                // Kruisdraden
                ShapePath {
                    strokeColor: "#444"; strokeWidth: 1
                    startX: 150; startY: 10; PathLine { x: 150; y: 290 }
                }
                ShapePath {
                    strokeColor: "#444"; strokeWidth: 1
                    startX: 10; startY: 150; PathLine { x: 290; y: 150 }
                }
            }

            // De "Puck" (Het balletje dat de G-kracht aangeeft)
            Rectangle {
                width: 20; height: 20; radius: 10
                color: "#ff0000"
                border.color: "white"; border.width: 2

                // Positie berekenen (Midden + G-waarde * Schaal)
                x: 140 + (gX * 100)
                y: 140 + (gY * 100)

                Behavior on x { SmoothedAnimation { velocity: 500 } }
                Behavior on y { SmoothedAnimation { velocity: 500 } }

                // 'Trail' effect (Spoor)
                layer.enabled: true
                layer.effect: MultiEffect { shadowEnabled: true; shadowColor: "#ff0000"; shadowBlur: 1.0 }
            }
        }

        // Tekstuele waarden
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 40
            Text { text: "LAT: " + gX.toFixed(2) + " g"; color: "#888"; font.pixelSize: 18; font.bold: true; style: Text.Outline; styleColor: "black" }
            Text { text: "ACC: " + gY.toFixed(2) + " g"; color: "#888"; font.pixelSize: 18; font.bold: true; style: Text.Outline; styleColor: "black" }
        }
    }
}
