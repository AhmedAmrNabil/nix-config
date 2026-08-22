import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell.Services.Mpris

RowLayout {
    id: root
    property MprisPlayer player: Mpris.players.values.find(p => p.dbusName == "org.mpris.MediaPlayer2.spotify")

    spacing: 8

    ClippingRectangle {
        Layout.preferredHeight: 42
        Layout.preferredWidth: 42
        radius: 12
        visible: root.player && root.player.trackArtUrl
        Image {
            height: 42
            width: 42
            source: root.player ? root.player.trackArtUrl : ""
            sourceSize.width: 42
            sourceSize.height: 42
            fillMode: Image.PreserveAspectFit
        }
    }

    ColumnLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Text {
            Layout.alignment: Qt.AlignLeft
            text: root.player ? root.player.trackTitle : ""
            color: Theme.text
            font.pointSize: 12
            font.family: "SF Pro Rounded"
            font.weight: Font.DemiBold
            Layout.preferredWidth: 150
            elide: Text.ElideRight
        }
        Text {
            Layout.alignment: Qt.AlignLeft
            text: root.player ? root.player.trackArtist : ""
            color: Theme.textSecondary
            font.pointSize: 10
            font.family: "SF Pro Rounded"
            Layout.preferredWidth: 150
            elide: Text.ElideRight
        }
    }
}
