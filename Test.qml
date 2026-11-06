import Quickshell
import QtQuick

PanelWindow {
    anchors {
        top: true
        left: true
    }

    implicitWidth:  1200
    implicitHeight: 800

    CompositeImage {
        path: "/home/fruit/Pictures/water-memories-ortiz"
        gridSize: Qt.size(3, 4)
        tileSize: Qt.size(512, 512)
        clipSpace: Qt.rect(0, 0, 1024, 512)
    }
}
