import QtQuick
import QtQuick.Layouts

Item {
    id: root

    // Data die we nodig hebben van Main
    property int oilTemp: 0
    property int range: 0

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 40

        Text {
            text: "QUATTRO STATUS"
            color: "#444444"; font.bold: true; font.pixelSize: 24
            Layout.alignment: Qt.AlignHCenter
            style: Text.Outline; styleColor: "black"
        }

        RowLayout {
            spacing: 120
            Layout.alignment: Qt.AlignHCenter

            Column {
                Text { text: "OIL TEMP"; color: "#888888"; font.pixelSize: 16; font.bold: true; style: Text.Outline; styleColor: "black" }
                Text { text: root.oilTemp + "°C"; color: "white"; font.pixelSize: 32; font.bold: true; style: Text.Outline; styleColor: "black" }
            }
            Column {
                Text { text: "RANGE"; color: "#888888"; font.pixelSize: 16; font.bold: true; style: Text.Outline; styleColor: "black" }
                Text { text: root.range + " km"; color: "white"; font.pixelSize: 32; font.bold: true; style: Text.Outline; styleColor: "black" }
            }
        }

        // Decoratieve lijn
        Rectangle {
            height: 2; width: 400
            color: "#cc0000"
            Layout.alignment: Qt.AlignHCenter
            opacity: 0.5
        }
    }
}
