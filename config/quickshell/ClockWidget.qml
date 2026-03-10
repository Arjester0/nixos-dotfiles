import Quickshell
import QtQuick.Effects
import Quickshell.Io
import Quickshell.Wayland
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

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.anchors.bottom: true
    WlrLayershell.anchors.left: true
    WlrLayershell.margins.bottom: 12
    WlrLayershell.margins.left: 20
    WlrLayershell.exclusiveZone: 0

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
        source: "file:///home/arjester/Pictures/yuukawidget.jpeg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: false
	 }

    Rectangle {
        id: fadeMask
        anchors.fill: parent
        visible: false
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#ffffffff" }
            GradientStop { position: 0.6; color: "#ffffffff" }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }

    MultiEffect {
        source: yuukaImg
        anchors.fill: parent
        maskEnabled: true
        maskSource: fadeMask
        maskThresholdMin: 0.0
        maskSpreadAtMin: 1.0
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
