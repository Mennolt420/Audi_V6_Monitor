import QtQuick
import QtQuick.Layouts

Rectangle {
    height: 80
    color: "transparent"
    signal tabClicked(string tabName)
    property string activeTab: "CAR"

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: "black"
        }
        GradientStop {
            position: 1.0
            color: "transparent"
        }
    }

    RowLayout {
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 80 // Meer ruimte tussen de items nu er eentje weg is

        Repeater {
            model: ["CAR", "MEDIA", "NAV"]
            Text {
                text: modelData
                color: parent.parent.activeTab === modelData ? "white" : "#666666"
                font.pixelSize: 22
                font.bold: true
                font.family: "Titillium Web"
                style: Text.Outline
                styleColor: "black"

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -10
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

                    // Klein gloed effectje op het actieve balkje
                    layer.enabled: true
                }
            }
        }
    }
}
