import QtQuick
import QtQuick.Layouts

Item {
    id: root

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        // Album Art
        Rectangle {
            width: 220; height: 220
            color: "#111"
            border.color: "#333"; border.width: 2
            radius: 10
            Layout.alignment: Qt.AlignHCenter

            // Muzieknoot icoon
            Text {
                anchors.centerIn: parent
                text: "♫"
                color: "#444"
                font.pixelSize: 100
            }
        }

        Text {
            text: "Bluetooth Audio"
            color: "#888888"
            font.pixelSize: 20
            Layout.alignment: Qt.AlignHCenter
            style: Text.Outline; styleColor: "black"
        }
        Text {
            text: "Dire Straits - Sultans of Swing"
            color: "white"
            font.pixelSize: 32
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            style: Text.Outline; styleColor: "black"
        }
        Text {
            text: "Bose Surround Active"
            color: "#cc0000"
            font.pixelSize: 14
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            style: Text.Outline; styleColor: "black"
        }
    }
}
