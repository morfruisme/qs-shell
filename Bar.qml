import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

pragma ComponentBehavior: Bound

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "bar"

    anchors {
        top: true
        left: true
        right: true
    }

    color: "#a89fad"
    implicitHeight: 30

    default property list<Item> items
    property Component separator: Item { Layout.fillWidth: true }

    RowLayout {
        id: row
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height
        width: 300

    }

    Component.onCompleted: {
        items.forEach((item, i) => {
            if (i > 0)
                separator.createObject(row)
            item.parent = row
        })
    }
}
