import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

ShellRoot {
    PanelWindow {
        id: barWindow
        anchors.top: true
        implicitHeight: 44
        color: "transparent"
        exclusionMode: ExclusionMode.Normal
        exclusiveZone: implicitHeight
    }

    PanelWindow {
        id: overlayWindow
        property int pillState: Pill.State.Collapsed
        visible: true
        anchors.top: true
        exclusionMode: ExclusionMode.Ignore
        color: "transparent"
        implicitHeight: pillContainer.implicitHeight
        implicitWidth: pillContainer.implicitWidth
        margins.top: 4

        Rectangle {
            id: pillContainer
            implicitWidth: overlayWindow.pillState === Pill.State.Expanded ? 600 : 150
            implicitHeight: overlayWindow.pillState === Pill.State.Expanded ? 100 : 36
            color: Theme.mantle
            radius: 32
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

            SpringBehavior on implicitWidth {}
            SpringBehavior on implicitHeight {}

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    overlayWindow.pillState = overlayWindow.pillState === Pill.State.Expanded ? Pill.State.Collapsed : Pill.State.Expanded;
                }
            }

            CollapsedView {
                anchors.fill: parent
                visible: overlayWindow.pillState === Pill.State.Collapsed
                opacity: visible ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                    }
                }
            }

            ExpandedView {
                anchors.fill: parent
                visible: overlayWindow.pillState === Pill.State.Expanded
                opacity: visible ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                    }
                }
            }
        }
    }
}
