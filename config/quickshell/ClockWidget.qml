import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

FloatingWindow {
    id: root
    visible: true
    implicitWidth: 430
    implicitHeight: 185
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.anchors.bottom: true
    WlrLayershell.anchors.left: true
    WlrLayershell.margins.bottom: 18
    WlrLayershell.margins.left: 18
    WlrLayershell.exclusiveZone: 0

    property string timeText: "00:00"
    property string dateText: "Monday, January 01"
    property string quoteText: "Still singing through the static."
    property var quotes: [
        "Still singing through the static.",
        "Next signal: stellar blue.",
        "A sharper orbit starts now.",
        "Keep the stage dark. Let the cyan speak.",
        "Sui-chan wa kyou mo kawaii."
    ]
    property int quoteIndex: 0

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            timeProc.running = true
            dateProc.running = true
        }
    }

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

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: "#050914cc"
        border.color: "#7FE7F566"
        border.width: 1
    }

    Column {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 6

        Text {
            text: "HOSHIMACHI SUISEI  星街すいせい"
            color: "#7FE7F5"
            font.family: "JetBrains Mono"
            font.pixelSize: 13
            font.bold: true
        }

        Text {
            text: root.timeText
            color: "#E8F0FF"
            font.family: "JetBrains Mono"
            font.pixelSize: 58
            font.bold: true
        }

        Text {
            text: root.dateText
            color: "#9BD7FF"
            font.family: "JetBrains Mono"
            font.pixelSize: 15
            font.bold: true
        }

        Rectangle {
            width: parent.width
            height: 1
            color: "#7FE7F544"
        }

        Text {
            text: root.quoteText
            color: "#B8A0FFcc"
            font.family: "JetBrains Mono"
            font.pixelSize: 13
            font.italic: true
        }
    }
}
