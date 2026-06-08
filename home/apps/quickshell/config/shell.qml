//@ pragma UseQApplication
import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import "ViewState.qml"

ShellRoot {
    // You need a PwObjectTracker to "bind" a node before accessing its audio properties
    PanelWindow {
        id: panel
        implicitHeight: 44
        anchors.top: true
        anchors.left: true
        anchors.right: true
        color: "transparent"
    }

    PanelWindow {
        id: pill
        anchors.left: true
        anchors.right: true
        anchors.top: true
        exclusionMode: ExclusionMode.Ignore
        color: "transparent"

        // Follow the animated rect size, not child directly
        implicitHeight: animatedContainer.height + 8
        implicitWidth: animatedContainer.width + 8

        ClippingRectangle {
            id: animatedContainer
            anchors.centerIn: parent

            // Animate size changes
            Behavior on width {
                SpringAnimation {
                    spring: 15
                    damping: 0.8
                    mass: 1
                }
            }
            Behavior on height {
                SpringAnimation {
                    spring: 15
                    damping: 0.8
                    mass: 1
                }
            }

            // Track the loader's actual content size
            width: loaderItem.implicitWidth + 16
            height: loaderItem.implicitHeight + 16

            radius: 22
            color: Theme.crust

            Row {
                id: child
                anchors.centerIn: parent

                Component {
                    id: defaultPillComp
                    DefaultPill {}
                }
                Component {
                    id: audioPillComp
                    AudioPill {}
                }

                Loader {
                    id: loaderItem
                    sourceComponent: {
                        switch (ViewState.activeView) {
                        case ViewState.Views.ViewDefault:
                            return defaultPillComp;
                        case ViewState.Views.ViewAudio:
                            return audioPillComp;
                        default:
                            return defaultPillComp;
                        }
                    }
                }
            }
        }
    }
}
