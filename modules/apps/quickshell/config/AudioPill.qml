import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Pipewire
import Quickshell.Widgets

RowLayout {
    id: root
    width: 240
    height: 28
    spacing: 12

    readonly property real volume: {
        const sink = Pipewire.defaultAudioSink;
        if (!sink || !sink.audio)
            return 0;
        return sink.audio.volume;
    }
    readonly property bool muted: Pipewire.defaultAudioSink?.audio?.muted ?? false

    Text {
        text: {
            // volume == 0 ? "" : (volume < 0.5 ? "" : "")
            if (root.muted)
                return "";
            if (root.volume == 0)
                return "";
            else if (root.volume < 0.5)
                return "";
            else
                return "";
        }
        Layout.topMargin: 0.5
        color: Theme.text
        Layout.alignment: Qt.AlignVCenter
        verticalAlignment: Text.AlignVCenter           // add this
        font.pointSize: 10
        font.family: "JetBrains Mono Nerd Font Propo"
        Layout.preferredWidth: 15
    }

    Slider {
        id: slider
        from: 0
        value: root.volume
        to: 1

        Layout.preferredHeight: 8
        Layout.alignment: Qt.AlignVCenter
        Layout.fillWidth: true

        background: Rectangle {
            color: Theme.surface0
            radius: 8
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            width: slider.availableWidth
            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height
                radius: parent.radius
                color: root.muted ? Theme.disabled : Theme.primary
            }
        }

        handle: Rectangle {}
    }

    Text {
        text: {
            const sink = Pipewire.defaultAudioSink;
            if (!sink || !sink.audio)
                return "0%";
            return Math.round(sink.audio.volume * 100) + "%";
        }
        color: Theme.textSecondary
        // align text right
        horizontalAlignment: Text.AlignRight
        font.pointSize: 10
        font.family: "SF Pro Text"
        font.weight: Font.Medium
        Layout.preferredWidth: 30
    }
}
