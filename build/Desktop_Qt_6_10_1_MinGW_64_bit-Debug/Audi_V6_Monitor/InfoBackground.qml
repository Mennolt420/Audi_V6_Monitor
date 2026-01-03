import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#050505"
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#1a1a1a" }
        GradientStop { position: 1.0; color: "#000000" }
    }

    // Properties ontvangen van Main.qml
    property string activeTab: "CAR"
    property int oilTemp: 0
    property int range: 0

    StackLayout {
        anchors.fill: parent
        currentIndex: (activeTab === "CAR") ? 0 : (activeTab === "MEDIA" ? 1 : 2)

        // 0. Auto Tab
        TabCar {
            oilTemp: root.oilTemp
            range: root.range
        }

        // 1. Media Tab
        TabMedia {
            // Eventueel properties doorgeven voor artiest/titel
        }

        // 2. Navigatie Tab (De kaart)
        TabNavigation {
            // Eventueel coördinaten doorgeven
        }
    }
}
