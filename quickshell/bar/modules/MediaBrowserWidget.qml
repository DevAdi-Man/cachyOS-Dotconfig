import QtQuick
import Quickshell
import Quickshell.Io

// Combined screenshots/videos browser launcher.
// Left-click = screenshots, right-click = videos, middle-click / shift-click = Gyotaku OCR search. Sits left of the theme icon.
Item {
    id: rootMod
    required property var root
    property var screen: null

    implicitWidth: 22
    implicitHeight: 28

    Process {
        id: gyotakuProc
        command: ["bash", "-c", "$HOME/.local/bin/gyotaku-toggle"]
    }

    IconText {
        anchors.centerIn: parent
        text: "collections"
        font.pixelSize: 14
        font.weight: Font.Normal
        color: root.mediaBrowserVisible
            ? root.seal
            : Qt.rgba(root.ink.r, root.ink.g, root.ink.b, 0.65)
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    TooltipMixin {
        id: tip; root: rootMod.root; owner: rootMod
        text: "L: Screenshots  R: Videos  M: Gyotaku OCR"
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onEntered: tip.show()
        onExited:  tip.hide()
        onClicked: function(mouse) {
            tip.hide()
            if (mouse.button === Qt.MiddleButton || (mouse.button === Qt.LeftButton && (mouse.modifiers & Qt.ShiftModifier))) {
                if (root.mediaBrowserVisible) root.mediaBrowserVisible = false
                gyotakuProc.running = false
                gyotakuProc.running = true
                return
            }
            if (root.mediaBrowserVisible) {
                root.mediaBrowserVisible = false
                return
            }
            root.activatePopupScreen(rootMod.screen)
            root.mediaBrowserMode    = (mouse.button === Qt.RightButton) ? "videos" : "screenshots"
            root.mediaBrowserVisible = true
        }
    }
}
