pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property string time

    Process {
        id: proc
        command: ["date", "+%R"]
        running: true
        
        stdout: StdioCollector {
            onStreamFinished: root.time = this.text.trim()
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true

        onTriggered: proc.running = true
    }
}
