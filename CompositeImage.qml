import QtQuick

pragma ComponentBehavior : Bound

Item {
    id: root
    required property string path
    required property size gridSize
    required property size sourceTileSize // same size for all tiles for now

    property string ext: "jpg"
    property rect clipSpace: Qt.rect(0, 0, gridSize.width * tileSize.width, gridSize.height * tileSize.height) // part of the image shown, defaults to full image
    property real imgScale: 1.0
    property size tileSize: Qt.size(imgScale * sourceTileSize.width, imgScale * sourceTileSize.height)
    
    implicitWidth:  clipSpace.width
    implicitHeight: clipSpace.height
    // clip: true

    function isInside(x, y) { // check wether tile (x, y) falls inside the clip space
        const w = tileSize.width
        const h = tileSize.height
        return  x      * w < clipSpace.x + clipSpace.width
            && (x + 1) * w > clipSpace.x
            &&  y      * h < clipSpace.y + clipSpace.height
            && (y + 1) * h > clipSpace.y
    }

    Repeater {
        model: {        
            let tiles = []
            for (let x = 0; x < root.gridSize.width; x++)
                for (let y = 0; y < root.gridSize.height; y++)
                    tiles.push({ x: x, y: y })
            return tiles
        }

        delegate: Loader {
            id: loader
            required property var modelData
            property int tileX: modelData.x
            property int tileY: modelData.y

            active: root.isInside(tileX, tileY)
    
            sourceComponent: Item {
                Image {
                    source: `${root.path}/${loader.tileX}_${loader.tileY}.${root.ext}`
                    asynchronous: true

                    x: loader.tileX * root.tileSize.width  - root.clipSpace.x
                    y: loader.tileY * root.tileSize.height - root.clipSpace.y
                    width:  root.tileSize.width
                    height: root.tileSize.height
                }
                // Rectangle {
                //     x: loader.tileX * root.tileSize.width  - root.clipSpace.x
                //     y: loader.tileY * root.tileSize.height - root.clipSpace.y
                //     width:  root.tileSize.width
                //     height: root.tileSize.height

                //     color: "transparent"
                //     border.color: "black"

                //     Text {
                //         text: `${loader.tileX}, ${loader.tileY}, ${root.width}x${root.height}`
                //     }
                // }
            }
        }
    }
}
