import QtQuick
import QtQuick.Layouts
// Deze was de boosdoener, nu gefixt
import QtLocation
import QtPositioning
import QtQuick.Shapes
import QtQuick.Effects

// Voor mooie effecten op de pijl
Item {
    id: root

    Plugin {
        id: mapPlugin
        name: "osm"
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin

        // Locatie Heiloo/Alkmaar
        center: QtPositioning.coordinate(52.60, 4.70)

        // De echte Virtual Cockpit look:
        zoomLevel: 17.5
        tilt: 65 // Flink gekanteld voor diepte
        bearing: 0
        fieldOfView: 50
        copyrightsVisible: false // Maakt het schoner

        // Donkere filter voor nachtrit-sfeer
        Rectangle {
            anchors.fill: parent
            color: "#050505"
            opacity: 0.5
        }

        // --- DE AUTO (3D Pijl) ---
        MapQuickItem {
            id: carMarker
            coordinate: map.center
            anchorPoint.x: carItem.width / 2
            anchorPoint.y: carItem.height / 2

            sourceItem: Item {
                id: carItem
                width: 100
                height: 100

                // Blauwe gloed onder de auto
                Rectangle {
                    anchors.centerIn: parent
                    width: 60
                    height: 60
                    radius: 30
                    color: "#00ccff"
                    opacity: 0.4
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        blurEnabled: true
                        blurMax: 32
                        blur: 1.0
                    }
                }

                // De Pijl
                Shape {
                    anchors.centerIn: parent
                    width: 40
                    height: 50
                    ShapePath {
                        strokeColor: "white"
                        strokeWidth: 2
                        fillColor: "#00ccff"
                        startX: 20
                        startY: 0
                        PathLine {
                            x: 40
                            y: 50
                        }
                        PathLine {
                            x: 20
                            y: 35
                        }
                        PathLine {
                            x: 0
                            y: 50
                        }
                        PathLine {
                            x: 20
                            y: 0
                        }
                    }
                    // Schaduw
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: "black"
                        shadowVerticalOffset: 5
                    }
                }
            }
        }

        // --- HUD INSTRUCTIES (Zwevend) ---

        // Volgende Afslag
        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 110
            anchors.horizontalCenter: parent.horizontalCenter
            width: 350
            height: 90

            color: "#cc111111" // Semi-transparant
            radius: 10
            border.color: "#333"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 20

                Text {
                    text: "↱"
                    color: "white"
                    font.pixelSize: 50
                    font.bold: true
                }
                ColumnLayout {
                    spacing: 0
                    Text {
                        text: "150 m"
                        color: "#00ccff"
                        font.pixelSize: 28
                        font.bold: true
                        font.family: "Titillium Web"
                    }
                    Text {
                        text: "Stationsweg"
                        color: "#cccccc"
                        font.pixelSize: 18
                        font.family: "Titillium Web"
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }
}
