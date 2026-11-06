import Quickshell
import QtQuick
import QtQuick.Controls

import "singletons"

// todo: put everything into one variants
Scope {
    Variants {
        model: Quickshell.screens

        Scope {
            id: root
            required property ShellScreen modelData
            
            Bar {
                screen: root.modelData

                StyledText {
                    text: `${Time.time}`
                }
                Slider {
                    from: 0
                    to: 100
                    stepSize: 1

                    value: brightness.value
                    onMoved: brightness.set(value)
                }
                StyledText {
                    text: " >///<: "
                }
            }

            Brightness {
                id: brightness
                screen: root.modelData
            }
        }
    }
        
    Wallpaper {
        path: "/home/fruit/Pictures/wm-36"
        offset: Qt.point(100, 10)
        invertXY: true
    }
    // Test {}
}
