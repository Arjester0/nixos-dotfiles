//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QSG_RENDER_LOOP=threaded
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import "modules"
import Quickshell
import QtQuick 

FloatingWindow {
    visible: true
    width: 200
    height: 100

    Text {
	anchors.centerIn: parent
	text: "Hello, Quickshell"
	color: "#0db9d7"
	font.pixelSize: 18
    }
} 
