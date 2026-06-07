import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "SpringBehavior.qml"

ShellRoot {
    PanelWindow {
        id: barWindow
        anchors.top: true
        implicitWidth: 200
        implicitHeight: 38
        color: "transparent"
        exclusionMode: ExclusionMode.Normal
        exclusiveZone: implicitHeight
    }

    PanelWindow {
        id: clickCatcher
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: "transparent"
        visible: overlayWindow.expanded  // only active when overlay is open
        exclusionMode: ExclusionMode.Ignore

        MouseArea {
            anchors.fill: parent
            onClicked: overlayWindow.expanded = false
        }
    }

    PanelWindow {
        id: overlayWindow
        property var expanded: false
        implicitWidth: expanded ? 400 : 200
        implicitHeight: expanded ? 300 : 32
        visible: true
        anchors.top: true
        exclusionMode: ExclusionMode.Ignore
        color: "transparent"
        margins.top: 4
        Rectangle {
            anchors.fill: parent
            color: "#1e1e2e"
            radius: 16

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    overlayWindow.expanded = !overlayWindow.expanded;
                    console.log("Overlay window expanded:", overlayWindow.expanded);
                }
            }

            // Text {
            //     anchors.centerIn: parent
            //     text: "Overlay Content"
            //     color: "#cdd6f4"
            // }
        }
        SpringBehavior on implicitWidth {}
        SpringBehavior on implicitHeight {}
    }
}
