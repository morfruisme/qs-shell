import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

pragma ComponentBehavior: Bound

Scope {
    id: root
    required property string path

    property size gridSize
    property size tileSize
    property point offset: Qt.point(0, 0)
    property bool invertXY: false

    property rect bgSpace: {    
        let s0 = Quickshell.screens[0]
        
        let minX = s0.x
        let minY = s0.y
        let maxX = s0.x + s0.width
        let maxY = s0.y + s0.height

        Quickshell.screens.forEach(s => {
            if (s.x            < minX) minX = s.x
            if (s.y            < minY) minY = s.x
            if (s.x + s.width  > maxX) maxX = s.x + s.width
            if (s.y + s.height > maxY) maxY = s.y + s.height   
        })

        return Qt.rect(minX, minY, maxX - minX, maxY - minY)
    }

    // todo: create the "format" file if doesn't exist ?
    Process {
        id: imageSizeProc
        command: ["cat", `${root.path}/info`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let [g, t] = this.text.split("\n")
                let [gw, gh] = g.split("x").map(x => parseInt(x))
                let [tw, th] = t.split("x").map(x => parseInt(x))
                root.gridSize.width  = gw
                root.gridSize.height = gh
                root.tileSize.width  = tw
                root.tileSize.height = th
            }
        }
    }
    
    Variants {
        model: Quickshell.screens
        // model: Quickshell.screens.filter(s => s.name == "HDMI-A-2")

        delegate: PanelWindow {
            id: bg
            required property var modelData
            screen: modelData

            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.namespace: "wallpaper"
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            CompositeImage {
                id: img

                path: root.path
                gridSize: root.gridSize
                sourceTileSize: root.tileSize

                imgScale: {
                    let sw = root.bgSpace.width  + root.offset.x
                    let sh = root.bgSpace.height + root.offset.y
                    let iw = root.gridSize.width  * root.tileSize.width
                    let ih = root.gridSize.height * root.tileSize.height
                    return root.invertXY ? Math.max(sh / iw, sw / ih) : Math.max(sw / iw, sh / ih)
                }

                clipSpace: {
                    let x = root.offset.x + bg.screen.x - root.bgSpace.x
                    let y = root.offset.y + bg.screen.y - root.bgSpace.y
                    let w = bg.screen.width
                    let h = bg.screen.height
                    return root.invertXY ? Qt.rect(y, x, h, w) : Qt.rect(x, y, w, h)
                }

                transform: [
                    Rotation { angle: root.invertXY ? -90 : 0 },
                    Scale { yScale: root.invertXY ? -1 : 1 }
                ]
            }

            // Rectangle {
            //     x: 10
            //     y: 10
            //     width: text.width
            //     height: text.height
            //     color: "white"
                
            //     Text {
            //         id: text
            //         text: `(${bg.screen.x}, ${bg.screen.y}) ${bg.screen.width}x${bg.screen.height}\n(${root.bgSpace.x}, ${root.bgSpace.y}) ${root.bgSpace.width}x${root.bgSpace.height}`
            //     }
            // }
        }
    }
}

