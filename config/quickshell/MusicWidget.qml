import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

// Music widget — bottom center, shows MPRIS player info + cava bars
FloatingWindow {
    id: root
    visible: true
    color: "transparent"
    width: 420
    height: 80

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.anchors {
        bottom: true
    }
    WlrLayershell.margins {
        bottom: 12
    }
    WlrLayershell.exclusiveZone: 0

    // Player state
    property string trackTitle: ""
    property string trackArtist: ""
    property string playerStatus: "Stopped"
    property bool isPlaying: false

    // Cava bars data
    property var cavaBars: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    property int barCount: 15

    // Poll playerctl every 2 seconds
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            titleProc.running = true
            artistProc.running = true
            statusProc.running = true
        }
    }

    // Cava via fifo — poll every 100ms for smooth animation
    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: cavaProc.running = true
    }

    Process {
        id: titleProc
        command: ["playerctl", "metadata", "title"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.trackTitle = this.text.trim()
        }
    }

    Process {
        id: artistProc
        command: ["playerctl", "metadata", "artist"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.trackArtist = this.text.trim()
        }
    }

    Process {
        id: statusProc
        command: ["playerctl", "status"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.playerStatus = this.text.trim()
                root.isPlaying = (root.playerStatus === "Playing")
            }
        }
    }

    // Read cava output from fifo
    // Requires cava running with raw output to /tmp/cava-fifo
    Process {
        id: cavaProc
        command: ["cat", "/tmp/cava-fifo"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                var line = this.text.trim()
                if (line.length > 0) {
                    var vals = line.split(";").filter(v => v.length > 0)
                    var bars = []
                    for (var i = 0; i < Math.min(vals.length, root.barCount); i++) {
                        bars.push(parseInt(vals[i]) / 1000.0)
                    }
                    root.cavaBars = bars
                }
            }
        }
    }

    // Background pill — semi-transparent navy
    Rectangle {
        anchors.fill: parent
        radius: 16
        color: "#0D1B2ADD"
        border.color: "#4DB8FF33"
        border.width: 1
    }

    Row {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Play/pause icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.isPlaying ? "󰏤" : "󰐊"
            color: root.isPlaying ? "#7FE7F5" : "#6A8AAA"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 22

            MouseArea {
                anchors.fill: parent
                onClicked: playPauseProc.running = true
            }
        }

        // Track info + cava bars
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
            width: parent.width - 80

            // Track title
            Text {
                text: root.trackTitle.length > 0 ? root.trackTitle : "Nothing playing"
                color: "#C8D8F0"
                font.family: "JetBrains Mono"
                font.pixelSize: 13
                font.bold: true
                elide: Text.ElideRight
                width: parent.width
            }

            // Artist
            Text {
                text: root.trackArtist
                color: "#6A8AAA"
                font.family: "JetBrains Mono"
                font.pixelSize: 11
                elide: Text.ElideRight
                width: parent.width
                visible: root.trackArtist.length > 0
            }

            // Cava visualizer bars
            Row {
                spacing: 3
                height: 20

                Repeater {
                    model: root.barCount
                    Rectangle {
                        width: 6
                        height: Math.max(2, (root.cavaBars[index] || 0) * 20)
                        anchors.bottom: parent.bottom
                        radius: 2
                        color: {
                            var h = index / root.barCount
                            if (h < 0.4) return "#7FE7F5"
                            else if (h < 0.7) return "#4DB8FF"
                            else return "#B8A0FF"
                        }

                        Behavior on height {
                            NumberAnimation { duration: 80; easing.type: Easing.OutQuad }
                        }
                    }
                }
            }
        }

        // Skip button
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "󰒭"
            color: "#6A8AAA"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 18

            MouseArea {
                anchors.fill: parent
                onClicked: nextProc.running = true
            }
        }
    }

    Process {
        id: playPauseProc
        command: ["playerctl", "play-pause"]
        running: false
    }

    Process {
        id: nextProc
        command: ["playerctl", "next"]
        running: false
    }
}
