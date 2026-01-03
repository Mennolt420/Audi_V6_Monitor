import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property string activeTab: "CAR" // Standaard tab

    // Achtergrond (optioneel, voor als de kaart laadt)
    Rectangle {
        anchors.fill: parent
        color: "transparent"
    }

    // Inhoud Wisselaar
    StackLayout {
        anchors.fill: parent
        currentIndex: (activeTab === "CAR") ? 0 : (activeTab === "MEDIA" ? 1 : 2)

        // 0. CAR INFO
        Item {
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20
                Text {
                    text: "AUDI TT 3.2 QUATTRO"
                    color: "#444444"; font.bold: true; font.pixelSize: 40; Layout.alignment: Qt.AlignHCenter
                }
                RowLayout {
                    spacing: 50
                    Layout.alignment: Qt.AlignHCenter
                    Column {
                        Text { text: "CONSUMPTION"; color: "#888888"; font.pixelSize: 14 }
                        Text { text: "9.8 l/100km"; color: "white"; font.pixelSize: 28; font.bold: true }
                    }
                    Column {
                        Text { text: "OIL TEMP"; color: "#888888"; font.pixelSize: 14 }
                        Text { text: "94°C"; color: "white"; font.pixelSize: 28; font.bold: true }
                    }
                }
            }
        }

        // 1. MEDIA
        Item {
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 15
                Rectangle {
                    width: 150; height: 150
                    color: "#222222"; radius: 10; border.color: "#333333"
                    Text { anchors.centerIn: parent; text: "🎵"; font.pixelSize: 60; color: "#666" }
                    Layout.alignment: Qt.AlignHCenter
                }
                Text { text: "Bluetooth Audio"; color: "#888888"; font.pixelSize: 18; Layout.alignment: Qt.AlignHCenter }
                Text { text: "Unknown Artist"; color: "white"; font.pixelSize: 32; font.bold: true; Layout.alignment: Qt.AlignHCenter }
            }
        }

        // 2. NAV (Map Simulatie)
        Rectangle {
            color: "#111111"
            // Hier zou je later een echte Map plugin laden

            // Grid simulatie voor map effect
            Repeater {
                model: 10
                Item {
                    Rectangle { y: index * 80; width: 1920; height: 2; color: "#222222" }
                    Rectangle { x: index * 200; width: 2; height: 720; color: "#222222" }
                }
            }

            // Nav pijl
            Text {
                anchors.centerIn: parent
                text: "➤"
                color: "#00ccff"
                font.pixelSize: 60
                rotation: -45
            }
            Text {
                anchors.bottom: parent.bottom; anchors.bottomMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                text: "A9 - Heiloo"
                color: "white"
                font.bold: true; font.pixelSize: 32
                style: Text.Outline; styleColor: "black"
            }
        }
    }
}
