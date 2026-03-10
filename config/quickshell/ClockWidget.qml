import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

// Overlay widget — bottom left, no background, blends into wallpaper
// Shows: Yuuka art | clock + date + BA quote
FloatingWindow {
    id: root
    visible: true
    width: 680
    height: 260
    color: "transparent"

    // Position: bottom left, above taskbar
    screen: Quickshell.screens[0]

    // QML doesn't have direct x/y on FloatingWindow — use a wrapper
    // Place via margins from edges
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.anchors {
        bottom: true
        left: true
    }
    WlrLayershell.margins {
        bottom: 12
        left: 20
    }
    WlrLayershell.exclusiveZone: 0  // don't push other windows

    property string timeText: "00:00"
    property string dateText: "Monday, January 01"
    property string quoteText: "Even the most difficult mission\ncan be accomplished with the right team."

    // BA quotes rotation
    property var quotes: [
        "Even the most difficult mission\ncan be accomplished with the right team.",
        "Sensei, I'll always be by your side.",
        "The future is something we create\ntogether.",
        "Every student has potential\nwaiting to be unlocked.",
        "Difficulties are just opportunities\nin disguise, Sensei.",
        "Trust in your students,\nand they will surpass your expectations.",
        "No matter how dark the night,\ndawn always follows.",
        "The bonds we form are\nstronger than any obstacle.",
    ]
    property int quoteIndex: 0

    // Update clock every second
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            timeProc.running = true
            dateProc.running = true
        }
    }

    // Rotate quote every 5 minutes
    Timer {
        interval: 300000
        running: true
        repeat: true
        onTriggered: {
            root.quoteIndex = (root.quoteIndex + 1) % root.quotes.length
            root.quoteText = root.quotes[root.quoteIndex]
        }
    }

    Process {
        id: timeProc
        command: ["date", "+%H:%M"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.timeText = this.text.trim()
        }
    }

    Process {
        id: dateProc
        command: ["date", "+%A, %B %d"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.dateText = this.text.trim()
        }
    }

    // Main layout: Yuuka left | text right
    Row {
        anchors.fill: parent
        spacing: 0

        // Yuuka image — fades into transparency on right edge
        Item {
            width: 220
            height: 260

            Image {
                id: yuukaImg
                source: "file:///home/arjester/Pictures/yuuka-widget.png"
                width: 220
                height: 260
                fillMode: Image.PreserveAspectCrop
                anchors.fill: parent
                smooth: true

                // Fade right edge into transparent
                layer.enabled: true
                layer.effect: ShaderEffect {
                    fragmentShader: "
                        uniform lowp sampler2D source;
                        uniform lowp float qt_Opacity;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            // fade out toward right edge
                            float fade = 1.0 - smoothstep(0.55, 1.0, qt_TexCoord0.x);
                            // also fade bottom edge slightly
                            float fadeBottom = 1.0 - smoothstep(0.85, 1.0, qt_TexCoord0.y);
                            gl_FragColor = tex * qt_Opacity * fade * fadeBottom;
                        }
                    "
                }
            }
        }

        // Text: clock, date, quote
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6
            leftPadding: 8

            // Time
            Text {
                text: root.timeText
                color: "#E8F0FF"
                font.family: "JetBrains Mono"
                font.pixelSize: 72
                font.bold: true
                style: Text.Outline
                styleColor: "#1A2F4588"
            }

            // Date
            Text {
                text: root.dateText
                color: "#7FE7F5"
                font.family: "JetBrains Mono"
                font.pixelSize: 18
                font.bold: true
                style: Text.Outline
                styleColor: "#0D1B2A88"
            }

            // Divider
            Rectangle {
                width: 280
                height: 1
                color: "#4DB8FF44"
            }

            // Quote
            Text {
                text: root.quoteText
                color: "#B8A0FFcc"
                font.family: "JetBrains Mono"
                font.pixelSize: 13
                font.italic: true
                lineHeight: 1.4
                style: Text.Outline
                styleColor: "#00000088"

                Behavior on text {
                    SequentialAnimation {
                        NumberAnimation { target: quoteLabel; property: "opacity"; to: 0; duration: 400 }
                        PropertyAction {}
                        NumberAnimation { target: quoteLabel; property: "opacity"; to: 1; duration: 400 }
                    }
                }
                id: quoteLabel
            }
        }
    }
}
