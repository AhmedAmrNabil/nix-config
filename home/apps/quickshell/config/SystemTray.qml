// this should show the system tray and network and bluetooth icons
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Networking
import Quickshell.Bluetooth

Row {
    id: root
    spacing: 8

    readonly property WifiDevice wifiDevice: Networking.devices.values.find(dev => dev.type === DeviceType.Wifi)
    readonly property WiredDevice wiredDevice: Networking.devices.values.find(dev => dev.type === DeviceType.Wired)

    readonly property BluetoothAdapter bluetoothAdapter: Bluetooth.defaultAdapter

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        Text {
            visible: root.wiredDevice != null
            text: root.wiredDevice.connected ? "󰈁" : "󰈂"
            color: Theme.text
            font.pointSize: 14
        }

        Text {
            visible: root.wifiDevice != null && root.wiredDevice.connected === false
            text: root.wifiDevice.connected ? "󰖩" : "󰖪"
            color: Theme.text
            font.pointSize: 14
        }

        MouseArea {
            width: bluetoothIcon.width
            height: bluetoothIcon.height
            Text {
                id: bluetoothIcon
                visible: root.bluetoothAdapter != null
                text: BluetoothAdapterState.toString(root.bluetoothAdapter.state) == "Enabled" ? "󰂯" : "󰂲"
                color: Theme.text
                font.pointSize: 14
            }
            onClicked: {
                if (root.bluetoothAdapter.state === BluetoothAdapterState.Enabled) {
                    root.bluetoothAdapter.enabled = false;
                } else {
                    root.bluetoothAdapter.enabled = true;
                }
            }
        }

        Repeater {
            model: SystemTray.items
            delegate: MouseArea {
                id: trayIcon
                visible: modelData && modelData.hasMenu

                required property SystemTrayItem modelData
                width: 20
                height: 20

                Image {
                    anchors.fill: parent
                    source: trayIcon.modelData.icon
										sourceSize.width: trayIcon.width
										sourceSize.height: trayIcon.height
                }
            }
        }
    }
}
