import QtQuick
import QtQuick.Layouts

Rectangle {
    height: 80
    color: "transparent"
    signal tabClicked(string tabName)
    property string activeTab: "CAR"

    // We laden het font hier ook, of gebruiken een system fallback
    FontLoader {
        id: menuFont
        source: "assets/Audi_Type_Digital_20210706/Audi Type Digital/AudiType v4.03 TrueType OpenType/AudiType-Bold_4.03.ttf"
    }

    gradient: Gradient {
        GradientStop { position: 0.0; color: "black" }
        GradientStop { position: 1.0; color: "transparent" }
    }

    RowLayout {
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 80

        Repeater {
            model: ["CAR", "MEDIA", "NAV"]
            Text {
                text: modelData
                color: parent.parent.activeTab === modelData ? "white" : "#666666"
                font.pixelSize: 22
                font.family: menuFont.status === FontLoader.Ready ? menuFont.name : "Arial"
                font.bold: true
                style: Text.Outline; styleColor: "black"

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -10
                    onClicked: parent.parent.parent.tabClicked(modelData)
                }

                Rectangle {
                    visible: parent.parent.parent.activeTab === modelData
                    width: parent.width + 20
                    height: 3
                    color: "#cc0000"
                    anchors.top: parent.top
                    anchors.topMargin: -8
                    anchors.horizontalCenter: parent.horizontalCenter
                    layer.enabled: true
                }
            }
        }
    }
}
