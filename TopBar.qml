import QtQuick
import QtQuick.Layouts

Rectangle {
    height: 80
    color: "transparent" // Laat de gradient van InfoBackground erdoorheen

    // We sturen een signaal naar Main.qml als er geklikt wordt
    signal tabClicked(string tabName)
    property string activeTab: "CAR"

    // Zwarte fade van boven naar beneden voor leesbaarheid
    gradient: Gradient {
        GradientStop { position: 0.0; color: "black" }
        GradientStop { position: 1.0; color: "transparent" }
    }

    RowLayout {
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 60

        Repeater {
            model: ["CAR", "MEDIA", "NAV"]
            Text {
                id: tabLabel
                text: modelData
                color: parent.parent.activeTab === modelData ? "white" : "#666666"
                font.pixelSize: 24
                font.bold: true
                font.family: "Arial"

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -10 // Groter klikgebied
                    onClicked: parent.parent.parent.tabClicked(modelData)
                }

                // Het rode actieve streepje
                Rectangle {
                    visible: parent.parent.parent.activeTab === modelData
                    width: parent.width + 20
                    height: 3
                    color: "#cc0000"
                    anchors.top: parent.top
                    anchors.topMargin: -8
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
