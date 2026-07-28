import Quickshell
import Quickshell.Services.Pam
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Scope {
    id: root

    WlSessionLock {
        id: sessionLock
        locked: true

        surface: Component {
            WlSessionLockSurface {
                id: lockSurface
                color: "#050914"

                property string statusText: "Enter password"
                property bool checking: false

                PamContext {
                    id: pam
                    config: "quickshell"
                    user: Quickshell.env("USER") || "arjester"

                    onResponseRequiredChanged: {
                        if (responseRequired) {
                            respond(passwordInput.text)
                        }
                    }

                    onCompleted: function(result) {
                        lockSurface.checking = false

                        if (result === PamResult.Success) {
                            sessionLock.unlock()
                            Qt.quit()
                            return
                        }

                        lockSurface.statusText = "Authentication failed"
                        passwordInput.text = ""
                        passwordInput.forceActiveFocus()
                    }

                    onError: function(error) {
                        lockSurface.checking = false
                        lockSurface.statusText = "Authentication error"
                        passwordInput.text = ""
                        passwordInput.forceActiveFocus()
                    }

                    onMessageChanged: {
                        if (message.length > 0) {
                            lockSurface.statusText = message
                        }
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: "#050914"

                    Rectangle {
                        anchors.centerIn: parent
                        width: Math.min(parent.width - 48, 520)
                        height: 300
                        radius: 8
                        color: "#0d1b2aee"
                        border.color: passwordInput.activeFocus ? "#7fe7f5" : "#37506a"
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 28
                            spacing: 14

                            Text {
                                Layout.fillWidth: true
                                text: "arjester"
                                color: "#e8f0ff"
                                font.family: "JetBrains Mono"
                                font.pixelSize: 28
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                            }

                            Text {
                                Layout.fillWidth: true
                                text: lockSurface.statusText
                                color: lockSurface.statusText.indexOf("failed") >= 0 || lockSurface.statusText.indexOf("error") >= 0 ? "#ff6b7a" : "#9bd7ff"
                                font.family: "JetBrains Mono"
                                font.pixelSize: 13
                                horizontalAlignment: Text.AlignHCenter
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 46
                                radius: 6
                                color: "#07111f"
                                border.color: passwordInput.activeFocus ? "#7fe7f5" : "#24384f"
                                border.width: 1

                                TextInput {
                                    id: passwordInput
                                    anchors.fill: parent
                                    anchors.leftMargin: 14
                                    anchors.rightMargin: 14
                                    verticalAlignment: TextInput.AlignVCenter
                                    color: "#e8f0ff"
                                    selectionColor: "#7fe7f5"
                                    selectedTextColor: "#050914"
                                    font.family: "JetBrains Mono"
                                    font.pixelSize: 18
                                    echoMode: TextInput.Password
                                    focus: true

                                    Keys.onReturnPressed: lockSurface.submit()
                                    Component.onCompleted: forceActiveFocus()
                                }
                            }

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredWidth: 180
                                Layout.preferredHeight: 42
                                radius: 6
                                color: lockSurface.checking ? "#223142" : "#7fe7f5"

                                Text {
                                    anchors.centerIn: parent
                                    text: lockSurface.checking ? "Checking" : "Unlock"
                                    color: lockSurface.checking ? "#8aa2b8" : "#050914"
                                    font.family: "JetBrains Mono"
                                    font.pixelSize: 14
                                    font.bold: true
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    enabled: !lockSurface.checking
                                    onClicked: lockSurface.submit()
                                }
                            }
                        }
                    }
                }

                function submit() {
                    if (checking || passwordInput.text.length === 0) {
                        return
                    }

                    statusText = "Checking"
                    checking = true

                    if (!pam.start()) {
                        checking = false
                        statusText = "Unable to start authentication"
                    }
                }
            }
        }
    }
}
