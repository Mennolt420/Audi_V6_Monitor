import QtQuick
import QtLocation
import QtPositioning

Item {
    id: root

    // Plugin configuratie voor OpenStreetMap
    Plugin {
        id: mapPlugin
        name: "osm"
        // Tip: Voor productie kun je hier 'mapboxgl' gebruiken met een API key
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin

        // Start locatie (ergens in Nederland)
        center: QtPositioning.coordinate(52.3676, 4.9041) // Amsterdam
        zoomLevel: 14

        // Donkere modus simuleren over de kaart (Nachtrit gevoel)
        layer.enabled: true
        color: "#000000" // Fallback

        // We maken de kaart iets donkerder zodat de witte tellers eruit springen
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.4
        }

        // Navigatie Pijl (De auto)
        MapQuickItem {
            coordinate: map.center
            anchorPoint.x: arrow.width / 2
            anchorPoint.y: arrow.height / 2

            sourceItem: Text {
                id: arrow
                text: "➤"
                color: "#00ccff" // Audi cyaan/blauw accent
                font.pixelSize: 60
                style: Text.Outline; styleColor: "black"
                rotation: -45
            }
        }

        // Navigatie instructie overlay
        Column {
            anchors.top: parent.top
            anchors.topMargin: 150
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5

            Text {
                text: "100m"
                color: "white"
                font.pixelSize: 40
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                style: Text.Outline; styleColor: "black"
            }
            Text {
                text: "Rechtsaf slaan"
                color: "#cccccc"
                font.pixelSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
                style: Text.Outline; styleColor: "black"
            }
        }
    }
}
