import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#050505"
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

    property string activeTab: "CAR"
    property int oilTemp: 0
    property int range: 0

    StackLayout {
        anchors.fill: parent
        // Index mapping: CAR=0, MEDIA=1, NAV=2
        currentIndex: (activeTab === "CAR") ? 0 : (activeTab === "MEDIA" ? 1 : 2)

        // 0. Auto & G-Force
        TabCar {
            oilTemp: root.oilTemp
            range: root.range
        }

        // 1. Media
        TabMedia {}

        // 2. Navigatie
        TabNavigation {}
    }
}
