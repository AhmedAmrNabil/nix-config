import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Pipewire

Rectangle {
    id: root
    width: 100
    height: 20
    color: "transparent"
    SystemClock {
        id: clock
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent  // ← Important: fill the parent so hover works
        hoverEnabled: true    // ← Required to enable onEntered/onExited

        onEntered: {
            root.width = 500;
            root.height = 62;
        }
        onExited: {
            root.width = 100;
            root.height = 20;
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        Media {
            visible: mouseArea.containsMouse
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0  // ← Reduce spacing between time and date
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatDateTime(clock.date, "hh:mm")
                color: Theme.text
                font.pointSize: mouseArea.containsMouse ? 16 : 14
                font.family: "SF Pro Rounded"
                font.weight: Font.DemiBold
            }
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatDateTime(clock.date, "ddd, MMM d")
                color: Theme.textSecondary
                font.pointSize: mouseArea.containsMouse ? 12 : 10
                font.family: "SF Pro Rounded"
                visible: mouseArea.containsMouse
            }
        }

        SystemTray {
            visible: mouseArea.containsMouse
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }
        
    }
}
