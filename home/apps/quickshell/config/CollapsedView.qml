import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: collapsedView
    width: parent.width
    height: parent.height
    color: "transparent"

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Text {
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "hh:mm")
        color: "#cdd6f4"
        font.pointSize: 14
        font.weight: Font.DemiBold
        font.family: "SF Pro Rounded"
    }
}
