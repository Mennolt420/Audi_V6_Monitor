import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property int oilTemp: 0
    property int range: 0

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 30

        // Titel
        Text {
            text: "VEHICLE STATUS"
            color: "white"; font.bold: true; font.pixelSize: 22
            Layout.alignment: Qt.AlignHCenter
            style: Text.Outline; styleColor: "black"
        }

        RowLayout {
            spacing: 80
            Layout.alignment: Qt.AlignHCenter

            // Olie Temperatuur Balk
            Column {
                spacing: 5
                Text { text: "OIL TEMP"; color: "#888"; font.pixelSize: 14; font.bold: true }
                Row {
                    spacing: 10
                    Rectangle {
                        width: 150; height: 10; color: "#333"; radius: 5
                        Rectangle {
                            width: parent.width * (Math.min(root.oilTemp, 130) / 130); height: parent.height
                            color: root.oilTemp > 90 ? "white" : "#00ccff"
                            radius: 5
                        }
                    }
                    Text { text: root.oilTemp + "°C"; color: "white"; font.bold: true }
                }
            }

            // Brandstof / Range Balk
            Column {
                spacing: 5
                Text { text: "RANGE"; color: "#888"; font.pixelSize: 14; font.bold: true }
                Row {
                    spacing: 10
                    Rectangle {
                        width: 150; height: 10; color: "#333"; radius: 5
                        Rectangle {
                            width: parent.width * (root.range / 600); height: parent.height
                            color: "white"
                            radius: 5
                        }
                    }
                    Text { text: root.range + " km"; color: "white"; font.bold: true }
                }
            }
        }
    }
}
