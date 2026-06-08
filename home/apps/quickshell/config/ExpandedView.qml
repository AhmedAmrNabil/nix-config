import Quickshell
import QtQuick.Controls
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Networking
import Quickshell.Bluetooth

Rectangle {
    id: expandedView
    width: parent.width
    height: parent.height
    color: "transparent"
    implicitHeight: 100
    implicitWidth: 400

    property MprisPlayer player: {
        for (const p of Mpris.players.values) {
            if (p.dbusName == "org.mpris.MediaPlayer2.spotify")
                return p;
        }
        return null;
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    RowLayout {
        spacing: 20
        anchors.fill: parent
        anchors.margins: 12

        //  3 sections media, time, wifi/bluetooth/battery

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width / 3
            Image {
                id: albumArt
                source: expandedView.player ? expandedView.player.trackArtUrl : ""
                fillMode: Image.PreserveAspectCrop
                Layout.preferredWidth: 60
                Layout.preferredHeight: 60
                antialiasing: true
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                Text {
                    text: expandedView.player ? expandedView.player.trackTitle : ""
                    color: Theme.text
                    font.pointSize: 12
                    Layout.alignment: Qt.AlignLeft
                }
                Text {
                    text: expandedView.player ? expandedView.player.trackArtist : ""
                    color: Theme.subtext0
                    font.pointSize: 10
                    Layout.alignment: Qt.AlignLeft
                }
            }
            Item { Layout.fillWidth: true } // spacer
        }

        // middle section with time and date
        ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width / 3
            spacing: 4
            Text {
                text: Qt.formatDateTime(clock.date, "hh:mm")
                color: Theme.text
                font.pointSize: 22
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                // format as Sun, Jun 7
                text: Qt.formatDateTime(clock.date, "ddd, MMM d")
                color: Theme.subtext0
                font.pointSize: 10

                Layout.alignment: Qt.AlignHCenter
            }
        }

        // right section with wifi, bluetooth, battery

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width / 3
            spacing: 4
            Item { Layout.fillWidth: true } // spacer
            Text {
                visible: expandedView.wiredDevice != null
                text: expandedView.wiredDevice.connected ? "󰈁" : "󰈂"
                color: Theme.text
                font.pointSize: 16
            }

            Text {
                visible: expandedView.wifiDevice != null
                text: expandedView.wifiDevice.connected ? "󰖩" : "󰖪"
                color: Theme.text
                font.pointSize: 16
            }
        }
    }
    readonly property WifiDevice wifiDevice: Networking.devices.values.find(dev => dev.type === DeviceType.Wifi)
    readonly property WiredDevice wiredDevice: Networking.devices.values.find(dev => dev.type === DeviceType.Wired)
}
