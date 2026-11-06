import Quickshell
import Quickshell.Io

Scope {
    id: root
    required property ShellScreen screen
    property string script: Quickshell.shellPath("scripts/screen.nu")
    
    property int bus
    property int value

    Process {
        command: ["nu", "-n", "-c", `${root.script} bus ${root.screen.model}`]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.bus = parseInt(this.text.trim())
                getBrightnessProc.running = true
            }
        }
    } 

    Process {
        id: getBrightnessProc
        command: ["nu", "-n", "-c", `${root.script} brightness ${root.bus}`]
        running: false

        stdout: StdioCollector {
            onStreamFinished: root.value = parseInt(this.text.trim())
        }
    }
    
    function set(value: int) {
        root.value = value
        setBrightnessProc.running = true
    }
    
    Process {
        id: setBrightnessProc
        command: ["ddcutil", "setvcp", "--bus", root.bus, "10", root.value]
        running: false
    }
}
