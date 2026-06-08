// ViewState.qml
pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Pipewire

Singleton {
    id: root
    enum Views { ViewDefault, ViewAudio, ViewLauncher }

    // Define your states as an enum-like int or string
    property int activeView: ViewState.Views.ViewDefault  // 0 = default, 1 = audio, 2 = launcher, etc.


    // Other global state
    property bool launcherOpen: false
    property string currentApp: ""

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio ?? null
        function onVolumeChanged() {
            ViewState.activeView = ViewState.Views.ViewAudio;
            revertTimer.restart();
        }
        function onMutedChanged() {
            ViewState.activeView = ViewState.Views.ViewAudio;
            revertTimer.restart();
        }
    }

    Timer {
        id: revertTimer
        interval: 2000
        onTriggered: ViewState.activeView = ViewState.Views.ViewDefault
    }
}
